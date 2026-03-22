resource "aws_cloudwatch_event_rule" "snapshot_schedule" {
  name                = "${var.project_name}-snapshot-schedule"
  description         = "Triggers Lambda to create RDS snapshot"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.snapshot_schedule.name
  target_id = "CreateSnapshotLambda"
  arn       = aws_lambda_function.create_snapshot.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_snapshot.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.snapshot_schedule.arn
}
