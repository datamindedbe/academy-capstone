import json

import boto3


def get_snowflake_creds_from_sm(secret_name: str):
    sess = boto3.Session(region_name="eu-west-1")
    client = sess.client('secretsmanager')

    response = client.get_secret_value(
        SecretId=secret_name
    )

    creds = json.loads(response['SecretString'])
    return {
        "sfURL": f"{creds['URL']}",
        "sfPassword": creds["PASSWORD"],
        "sfUser": creds["USER_NAME"],
        "sfDatabase": creds["DATABASE"],
        "sfWarehouse": creds["WAREHOUSE"],
        "sfRole": creds["ROLE"]
    }
