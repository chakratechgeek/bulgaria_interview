import os
import boto3
from botocore.exceptions import ClientError
import psycopg2
import json

def get_secret():
    secret_name = "primary-db"
    region_name = "eu-west-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    secret = get_secret_value_response['SecretString']
    return json.loads(secret)

def lambda_handler(event, context):
        
    # Retrieve the secret
    db_credentials = get_secret()
    # Connect to your database# Connect to the PostgreSQL database
    conn = psycopg2.connect(
        host=db_credentials['host'],
        port=db_credentials['port'],
        dbname=db_credentials['dbname'],
        user=db_credentials['username'],
        password=db_credentials['password']
        )

    # Query your database
    with conn.cursor() as cur:
        query = """
            SELECT count(*) AS transaction_count
            FROM pg_stat_activity
            WHERE state = 'active'
            AND backend_start >= NOW() - INTERVAL '10 minutes';
        """

        cur.execute(query)
        result = cur.fetchall()
        transaction_count = result[0][0] # Assuming the result is not empty

    # Publish metrics to CloudWatch
    cloudwatch = boto3.client('cloudwatch')
    cloudwatch.put_metric_data(
        Namespace='YourNamespace',
        MetricData=[
            {
                'MetricName': 'NumberOfTransactionLast10min',
                'Value': transaction_count,
                'Unit': 'Count'
            },
        ]
    )

    return {
        'statusCode': 200,
        'body': 'Metrics published successfully'
    }
