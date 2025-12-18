schedule_by  = "id"
instance_ids = ["i-0357eabb96e6b266d"]

time_zone = "Asia/Kolkata"

# ----- Option A: Quick test (every 2 minutes) -----
# Runs in Asia/Kolkata time, but interval cron is time-zone agnostic.
#start_cron = "cron(0/2 * * * ? *)" # Every 2 minutes
#stop_cron  = "cron(1/2 * * * ? *)" # Every 2 minutes, offset by 1 minute

# ----- Option B: Weekdays only (IST) -----
# Uncomment to use fixed times in IST (no need to convert to UTC)
start_cron = "cron(15 19 ? * MON-FRI *)"   # 9:30? Note: 9:30 AM would be 30 9; use 9 AM = 0 9
stop_cron  = "cron(45 21 ? * MON-FRI *)"   # 6:30 PM? Use 6 PM = 0 18

# Correct examples:
# start_cron = "cron(0 9 ? * MON-FRI *)"    # 9:00 AM IST
# stop_cron  = "cron(30 18 ? * MON-FRI *)"  # 6:30 PM IST (if you want 6:30), else use 0 18 for 6:00 PM

# ----- Option C: Tags (alternative targeting) -----
# schedule_by = "tags"
# tag_key     = "AutoSchedule"
# tag_value   = "true"
