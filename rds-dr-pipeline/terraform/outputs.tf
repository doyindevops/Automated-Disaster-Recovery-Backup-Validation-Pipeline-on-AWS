output "vpc_id" {
  value = aws_vpc.main.id
}

output "rds_instance_id" {
  value = aws_db_instance.postgres.id
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}
output "snapshot_lambda_name" {
  value = aws_lambda_function.create_snapshot.function_name
}

output "eventbridge_rule_name" {
  value = aws_cloudwatch_event_rule.snapshot_schedule.name
}

output "snapshot_lambda_error_alarm_name" {
  value = aws_cloudwatch_metric_alarm.snapshot_lambda_errors.alarm_name
}
