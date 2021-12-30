import json

import boto3


def get_snowflake_creds_from_sm(secret_name: str, b3_session:boto3.Session):
    client = b3_session.client('secretsmanager')

    response = client.get_secret_value(
        SecretId=secret_name
    )
    creds = json.loads(response['SecretString'])
    return {
        "sfURL": f"{creds['URL']}.snowflakecomputing.com",
        "sfPassword": creds["PASSWORD"],
        "sfUser": creds["USER_NAME"],
    }
