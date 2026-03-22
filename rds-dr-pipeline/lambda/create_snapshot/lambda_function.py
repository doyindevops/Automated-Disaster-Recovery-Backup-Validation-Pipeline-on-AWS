import boto3
import os
import json
from datetime import datetime

rds = boto3.client("rds")
sns = boto3.client("sns")

DB_INSTANCE_IDENTIFIER = os.environ["DB_INSTANCE_IDENTIFIER"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]


def lambda_handler(event, context):
    timestamp = datetime.utcnow().strftime("%Y-%m-%d-%H-%M-%S")
    snapshot_id = f"{DB_INSTANCE_IDENTIFIER}-snapshot-{timestamp}"

    try:
        rds.create_db_snapshot(
            DBSnapshotIdentifier=snapshot_id,
            DBInstanceIdentifier=DB_INSTANCE_IDENTIFIER,
            Tags=[
                {"Key": "Project", "Value": "rds-dr-pipeline"},
                {"Key": "CreatedBy", "Value": "lambda"},
                {"Key": "Purpose", "Value": "backup"}
            ]
        )

        print(json.dumps({
            "message": "Snapshot creation started successfully",
            "snapshot_id": snapshot_id,
            "db_instance": DB_INSTANCE_IDENTIFIER
        }))

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Snapshot creation started successfully",
                "snapshot_id": snapshot_id
            })
        }

    except Exception as e:
        error_message = f"Snapshot creation failed for {DB_INSTANCE_IDENTIFIER}: {str(e)}"
        print(error_message)

        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="RDS Backup Failed",
            Message=error_message
        )

        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": error_message
            })
        }
