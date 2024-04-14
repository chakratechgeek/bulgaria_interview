resource "aws_cloudwatch_dashboard" "example" {
  dashboard_name = "example-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.db_instance["pgsql_db_primary"].id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.db_instance["pgsql_db_standby"].id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.db_instance["app_ec2"].id],

          ],
          view    = "timeSeries",
          stacked = false,
          region  = "eu-west-1",
          title   = "CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkPacketsIn", "InstanceId", aws_instance.db_instance["pgsql_db_primary"].id],
            ["AWS/EC2", "NetworkPacketsIn", "InstanceId", aws_instance.db_instance["pgsql_db_standby"].id],
            ["AWS/EC2", "NetworkPacketsIn", "InstanceId", aws_instance.db_instance["app_ec2"].id],

          ],
          view    = "timeSeries",
          stacked = false,
          region  = "eu-west-1",
          title   = "Network Packets In"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.db_instance["pgsql_db_primary"].id],
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.db_instance["pgsql_db_standby"].id],
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.db_instance["app_ec2"].id],

          ],
          view    = "timeSeries",
          stacked = false,
          region  = "eu-west-1",
          title   = "Status Check Failed"
        }
      }
    ]
  })
}
