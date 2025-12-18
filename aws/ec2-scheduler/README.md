# **AWS EC2 Scheduler with Terraform**

This project automates **start** and **stop** schedules for EC2 instances using **AWS EventBridge Scheduler**. It supports scheduling by **instance IDs** or **tags**, and allows specifying a **time zone** for cron expressions.

***

## **Features**

*   Start/Stop EC2 instances on a defined schedule.
*   Supports **Asia/Kolkata** or any IANA time zone.
*   Schedule by:
    *   **Instance IDs** (`schedule_by = "id"`)
    *   **Tags** (`schedule_by = "tags"`)
*   Uses **AWS EventBridge Scheduler** (no Lambda required for basic start/stop).
*   IAM role and policy automatically created for EventBridge.

***

## **Project Structure**

    .
    ├── main.tf          # Terraform resources for EventBridge schedules and IAM roles
    ├── variables.tf     # Input variables
    ├── terraform.tfvars # User-defined values (instance IDs, cron, time zone)

***

## **Prerequisites**

*   AWS CLI configured with appropriate credentials.
*   Terraform installed (v1.x recommended).
*   EC2 instance(s) in the target region.

***

## **IAM Permissions**

Terraform creates:

*   **Role** for EventBridge Scheduler.
*   **Policy** with:
    *   `ec2:StartInstances`
    *   `ec2:StopInstances`
    *   `ec2:DescribeInstances`

***

## **Usage**

1.  **Clone the repo**:
    ```bash
    git clone <repo-url>
    cd aws/ec2-scheduler
    ```

2.  **Update `terraform.tfvars`**:
    Example:
    ```hcl
    schedule_by  = "id"
    instance_ids = ["i-0357eabb96e6b266d"]
    time_zone    = "Asia/Kolkata"

    start_cron = "cron(0 9 ? * MON-FRI *)"    # 9:00 AM IST
    stop_cron  = "cron(30 18 ? * MON-FRI *)"  # 6:30 PM IST
    ```

3.  **Initialize and apply**:
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

***

## **Quick Test**

To test without waiting for scheduled time:

```hcl
start_cron = "cron(0/2 * * * ? *)" # Every 2 minutes
stop_cron  = "cron(1/2 * * * ? *)" # Every 2 minutes, offset by 1 minute
```

Apply and observe instance state changes.

***

## **Notes**

*   `schedule_expression_timezone` ensures cron runs in your specified time zone.
*   EventBridge does **not** run immediately after creation; it triggers at the next matching time.

***

## **Example Cron Expressions**

| Action | IST Time | Cron Expression             |
| ------ | -------- | --------------------------- |
| Start  | 9:00 AM  | `cron(0 9 ? * MON-FRI *)`   |
| Stop   | 6:30 PM  | `cron(30 18 ? * MON-FRI *)` |


