resource "aws_cloudwatch_event_rule" "every_ten_minutes" {
 name                = "every-ten-minutes"
 description         = "Fires every ten minutes"
 schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "run_lambda" {
 rule      = aws_cloudwatch_event_rule.every_ten_minutes.name
 target_id = "run_lambda_function"
 arn       = aws_lambda_function.example.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
 statement_id = "AllowExecutionFromCloudWatch"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.example.function_name
 principal     = "events.amazonaws.com"
 source_arn    = aws_cloudwatch_event_rule.every_ten_minutes.arn
}
