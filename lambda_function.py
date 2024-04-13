import os
import boto3
import psycopg2

def lambda_handler(event, context):
    # Connect to your database
    conn = psycopg2.connect(
        host=os.environ['DB_HOST'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
        dbname=os.environ['DB_NAME']
    )

    # Query your database
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM your_table")
        result = cur.fetchall()

    # Publish metrics to CloudWatch
    cloudwatch = boto3.client('cloudwatch')
    cloudwatch.put_metric_data(
        Namespace='YourNamespace',
        MetricData=[
            {
                'MetricName': 'YourMetricName',
                'Value': len(result),
                'Unit': 'Count'
            },
        ]
    )

    return {
        'statusCode': 200,
        'body': 'Metrics published successfully'
    }
