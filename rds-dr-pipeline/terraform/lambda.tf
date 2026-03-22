resource "aws_lambda_function" "create_snapshot" {
  function_name = "${var.project_name}-create-snapshot"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 60

  filename         = "${path.module}/../lambda/create_snapshot/function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/create_snapshot/function.zip")

  environment {
    variables = {
      DB_INSTANCE_IDENTIFIER = aws_db_instance.postgres.identifier
      SNS_TOPIC_ARN          = aws_sns_topic.alerts.arn
    }
  }

  tags = {
    Name = "${var.project_name}-create-snapshot"
  }
}
