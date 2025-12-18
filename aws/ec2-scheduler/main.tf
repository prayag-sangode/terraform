provider "aws" {
  region = "us-east-1"
}

# ------------------------------
# Dynamic Input Builder
# ------------------------------
locals {
  # Build raw objects
  id_based_input = {
    InstanceIds = var.instance_ids
  }

  tag_based_input = {
    Filters = [
      {
        Name   = "tag:${var.tag_key}"
        Values = [var.tag_value]
      }
    ]
  }

  # Conditional must return the same type; use JSON string
  scheduler_input_json = var.schedule_by == "id" ? jsonencode(local.id_based_input) : jsonencode(local.tag_based_input)

  # Precompute ARNs to avoid inline conditionals in blocks
  start_arn = var.schedule_by == "id" ? "arn:aws:scheduler:::aws-sdk:ec2:startInstances" : "arn:aws:scheduler:::aws-sdk:ec2:startInstancesByTags"
  stop_arn  = var.schedule_by == "id" ? "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"  : "arn:aws:scheduler:::aws-sdk:ec2:stopInstancesByTags"
}

# ------------------------------
# IAM Role for EventBridge Scheduler
# ------------------------------
resource "aws_iam_role" "eventbridge_role" {
  name = "eventbridge-ec2-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_policy" {
  name = "eventbridge-ec2-scheduler-policy"
  role = aws_iam_role.eventbridge_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

# ------------------------------
# START EC2
# ------------------------------
resource "aws_scheduler_schedule" "start_ec2" {
  name        = "start-ec2-weekdays"
  description = "Start EC2 based on cron"

  schedule_expression          = var.start_cron
  schedule_expression_timezone = var.time_zone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = local.start_arn
    role_arn = aws_iam_role.eventbridge_role.arn
    input    = local.scheduler_input_json
  }
}

# ------------------------------
# STOP EC2
# ------------------------------
resource "aws_scheduler_schedule" "stop_ec2" {
  name        = "stop-ec2-weekdays"
  description = "Stop EC2 based on cron"

  schedule_expression          = var.stop_cron
  schedule_expression_timezone = var.time_zone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = local.stop_arn
    role_arn = aws_iam_role.eventbridge_role.arn
    input    = local.scheduler_input_json
  }
}
