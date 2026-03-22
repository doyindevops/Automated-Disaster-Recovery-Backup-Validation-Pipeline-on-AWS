# Disaster Recovery Runbook

## Purpose

This runbook documents the backup, alerting, and restore validation workflow for the Automated RDS Backup & Restore Validation Pipeline on AWS.

## Environment

- Primary database: Amazon RDS PostgreSQL
- Region: us-east-1
- Backup method: manual RDS snapshots created by Lambda
- Scheduler: EventBridge
- Monitoring: CloudWatch
- Alerting: SNS email notification

## Recovery Targets

- **RPO:** 24 hours
- **RTO:** 30 to 60 minutes

## Backup Workflow

1. EventBridge triggers the snapshot Lambda function on schedule.
2. The Lambda function creates a manual snapshot of the primary RDS PostgreSQL instance.
3. CloudWatch logs record execution details.
4. If the Lambda function fails, CloudWatch tracks the error metric.
5. CloudWatch alarm sends a notification through SNS when errors meet the threshold.

## Restore Validation Workflow

1. Open Amazon RDS in AWS Console.
2. Go to Snapshots.
3. Select the latest available manual snapshot.
4. Choose **Actions → Restore snapshot**.
5. Restore the snapshot into a temporary PostgreSQL instance.
6. Wait until the restored database reaches the `Available` state.
7. Capture evidence that the restore completed successfully.
8. Delete the temporary restore database after validation.

## Failure Handling

### If snapshot Lambda fails
1. Review the Lambda result.
2. Check CloudWatch logs for the error.
3. Confirm whether the CloudWatch alarm entered the ALARM state.
4. Confirm SNS email notification was received.
5. Correct the issue and retest the Lambda.

### If restore fails
1. Confirm the selected snapshot is available.
2. Review the restore configuration.
3. Check instance class, subnet group, and security group settings.
4. Retry the restore with corrected parameters.

## Manual Recovery Procedure

1. Open Amazon RDS.
2. Select the latest valid manual snapshot.
3. Restore it into a temporary PostgreSQL instance.
4. Wait for the restored instance to become `Available`.
5. Use this as restore validation evidence.
6. Delete the restored test database after validation.

## Validation Checklist

- Snapshot exists
- Lambda execution succeeded
- EventBridge schedule exists
- CloudWatch logs captured execution
- CloudWatch alarm exists
- SNS email alert works
- Restored database reaches `Available`
- Restore-test database is deleted after use

## Cost Control Notes

- Use a small RDS instance class for demo environments
- Keep restore validation temporary
- Avoid leaving restore-test databases running
- Review and remove old manual snapshots when no longer needed