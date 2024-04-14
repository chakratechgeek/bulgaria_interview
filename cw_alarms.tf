resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  for_each = { for k, v in local.alarms : k => v.cpu_utilization }

  alarm_name          = "${each.key}-cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = each.value.metric_name
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = each.value.threshold
  alarm_description   = "Terraform deploy:This metric checks for high CPU utilization"
  alarm_actions       = []
  dimensions = {
    InstanceId = aws_instance.db_instance[each.key].id
  }
}

resource "aws_cloudwatch_metric_alarm" "network_packets_in" {
  for_each = { for k, v in local.alarms : k => v.network_packets_in }

  alarm_name          = "${each.key}-network-packets-in-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = each.value.metric_name
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Sum"
  threshold           = each.value.threshold
  alarm_description   = "Terraform deploy:This metric checks for high incoming network traffic"
  alarm_actions       = []
  dimensions = {
    InstanceId = aws_instance.db_instance[each.key].id
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  for_each = { for k, v in local.alarms : k => v.status_check_failed }

  alarm_name          = "${each.key}-status-check-failed-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = each.value.metric_name
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = each.value.threshold
  alarm_description   = "Terraform deploy:This metric checks for status check failures"
  alarm_actions       = []
  dimensions = {
    InstanceId = aws_instance.db_instance[each.key].id
  }
}