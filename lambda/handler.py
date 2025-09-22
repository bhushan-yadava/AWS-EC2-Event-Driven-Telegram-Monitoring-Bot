import boto3, os, json, requests

def lambda_handler(event, context):
    secret_name = os.environ["SECRET_NAME"]
    chat_id = os.environ["TELEGRAM_CHAT_ID"]

    # Retrieve bot token from AWS Secrets Manager
    sm_client = boto3.client("secretsmanager")
    secret_value = sm_client.get_secret_value(SecretId=secret_name)
    token = secret_value["SecretString"]

    # Format alert message
    message = f"🚨 EC2 Alert:\n{json.dumps(event, indent=2)}"

    # Send to Telegram
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    requests.post(url, data={"chat_id": chat_id, "text": message})

    return {"statusCode": 200, "body": "Notification sent to Telegram"}
