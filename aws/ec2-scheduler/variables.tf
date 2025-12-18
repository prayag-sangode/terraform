
variable "schedule_by" {
  description = "Choose method: id or tags"
  type        = string
  default     = "id"
}

variable "instance_ids" {
  description = "List of EC2 instance IDs"
  type        = list(string)
  default     = []
}

variable "tag_key" {
  description = "Tag key for selecting EC2 instances"
  type        = string
  default     = ""
}

variable "tag_value" {
  description = "Tag value for selecting EC2 instances"
  type        = string
  default     = ""
}

variable "start_cron" {
  description = "Cron schedule for starting EC2"
  type        = string
}

variable "stop_cron" {
  description = "Cron schedule for stopping EC2"
  type        = string
}

variable "time_zone" {
  description = "Time zone for the scheduler (IANA tz database name)"
  type        = string
  default     = "Asia/Kolkata" # IST
}
