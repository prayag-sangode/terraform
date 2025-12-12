provider "aws" {
  region = "ap-south-1"
}

# ------------------------------
# Dynamic Input Builder
# ------------------------------
locals {
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

  scheduler_input = var.schedule_by == "id" ? local.id_based_input : local.tag_based_input
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
# START EC2 (Mon-Fri 9 AM IST)
# ------------------------------
resource "aws_scheduler_schedule" "start_ec2" {
  name        = "start-ec2-weekdays"
  description = "Start EC2 Mon-Fri at 9 AM IST"

  schedule_expression = var.start_cron

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn = var.schedule_by == "id"
      ? "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
      : "arn:aws:scheduler:::aws-sdk:ec2:startInstancesByTags"

    role_arn = aws_iam_role.eventbridge_role.arn
    input    = jsonencode(local.scheduler_input)
  }
}

# ------------------------------
# STOP EC2 (Mon-Fri 6 PM IST)
# ------------------------------
resource "aws_scheduler_schedule" "stop_ec2" {
  name        = "stop-ec2-weekdays"
  description = "Stop EC2 Mon-Fri at 6 PM IST"

  schedule_expression = var.stop_cron

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn = var.schedule_by == "id"
      ? "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
      : "arn:aws:scheduler:::aws-sdk:ec2:stopInstancesByTags"

    role_arn = aws_iam_role.eventbridge_role.arn
    input    = jsonencode(local.scheduler_input)
  }
}
