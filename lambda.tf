resource "aws_lambda_function" "example" {
 function_name = "example_lambda"
 handler       = "lambda_function.lambda_handler"
 runtime       = "python3.10"
 role          = aws_iam_role.lambda_exec.arn
 filename      = "lambda_function.zip"

 
 
}

resource "aws_iam_role" "lambda_exec" {
 name = "lambda_exec_role"

 assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
 })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
 role       = aws_iam_role.lambda_exec.name
 policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
