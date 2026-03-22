resource "aws_cloudwatch_log_group" "create_snapshot_logs" {
  name              = "/aws/lambda/${var.project_name}-create-snapshot"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "snapshot_lambda_errors" {
  alarm_name          = "${var.project_name}-snapshot-lambda-errors"
  alarm_description   = "Alarm when snapshot Lambda records errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.create_snapshot.function_name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "${var.project_name}-snapshot-lambda-errors"
  }
}
