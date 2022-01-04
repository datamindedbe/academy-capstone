#!/usr/bin/env bash
set -exuo pipefail

image=summer-capstone:latest

docker build . -t ${image}

docker run \
  -it \
  -e AWS_ACCESS_KEY_ID=$1 \
  -e AWS_SECRET_ACCESS_KEY=$2 \
  -e AWS_REGION="eu-west-1" \
  ${image} python3 /opt/spark/work-dir/scripts/01_export_data_to_db.py