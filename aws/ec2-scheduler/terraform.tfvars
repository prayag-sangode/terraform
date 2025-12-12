# Option 1: Use Instance IDs
schedule_by  = "id"
instance_ids = ["i-0fd7b2fa91d10a07f"]

# Start and stop only Mon-Fri
start_cron = "cron(30 3 ? * MON-FRI *)"   # 9 AM IST
stop_cron  = "cron(30 12 ? * MON-FRI *)"  # 6 PM IST

# Option 2: Use tags
# schedule_by = "tags"
# tag_key     = "AutoSchedule"
# tag_value   = "true"
