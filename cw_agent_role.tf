

resource "aws_iam_role" "cloudwatch_agent_server_role" {
  name = "CloudWatchAgentServerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_retention_policy" {
  name        = "CloudWatchLogsRetentionPolicy"
  description = "Policy to allow putting a retention policy on CloudWatch logs"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:PutRetentionPolicy",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.cloudwatch_agent_server_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_retention_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy_attachment" {
  role       = aws_iam_role.cloudwatch_agent_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


# Optional: Attach AWSXRayDaemonWriteAccess policy if sending traces to X-Ray
resource "aws_iam_role_policy_attachment" "xray_daemon_write_access_policy_attachment" {
  role       = aws_iam_role.cloudwatch_agent_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
