import psycopg2
import redis

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

def get_user_data(username):
    db_credentials = get_secret()
    # Initialize Redis connection
    redis_client = redis.StrictRedis(host='master.example.0n7twd.euw1.cache.amazonaws.com:6379', port=6379, decode_responses=True)

    # Check if user data exists in cache
    user_data = redis_client.get(username)
    if user_data:
        print("User data found in cache:")
        return user_data

    # If user data not found in cache, fetch it from PostgreSQL
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(
        host=db_credentials['host'],
        port=db_credentials['port'],
        dbname=db_credentials['dbname'],
        user=db_credentials['username'],
        password=db_credentials['password']
        )

        cursor = conn.cursor()

        # Query user data from PostgreSQL
        cursor.execute("SELECT * FROM user_data WHERE username = %s", (username,))
        user_data = cursor.fetchone()

        if user_data:
            # Store user data in cache
            redis_client.set(username, str(user_data))
            print("User data stored in cache:")
            return user_data
        else:
            return "User not found in PostgreSQL database"

    except (Exception, psycopg2.Error) as error:
        print("Error while fetching data from PostgreSQL:", error)
        return None

    finally:
        # Close PostgreSQL connection
        if conn:
            cursor.close()
            conn.close()

# Example usage
username = "chakra_user"
print(get_user_data(username))
