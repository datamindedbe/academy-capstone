#!/usr/bin/env bash
set -exuo pipefail

image=summer-capstone:latest

docker build . -t ${image}

#credentials=$(aws sts assume-role --role-arn arn:aws:iam::130966031144:role/summer-capstone-role --role-session-name test-session | jq -r ".Credentials")
#AccessKeyId=$(echo $credentials | jq -r ".AccessKeyId")
#SecretAccessKey=$(echo $credentials | jq -r ".SecretAccessKey")
#SessionToken=$(echo $credentials | jq -r ".SessionToken")

docker run \
  -it \
  -e AWS_ACCESS_KEY_ID="AKIAU5YMQWRQ2FQUKIOC" \
  -e AWS_SECRET_ACCESS_KEY="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" \
  -e AWS_REGION="eu-west-1" \
  ${image} python3 /opt/spark/work-dir/scripts/01_export_data_to_db.py