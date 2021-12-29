# Data Minded Academy Capstone
Welcome to the Capstone project! During the next 1.5 days you will apply everything you've learned during the past days 
in an integrated exercise. You will:
1) Read, transform and load weather data from S3 to Snowflake through PySpark
2) Build dashboards with SQL on Snowflake
3) Take a stab at running your application on AWS through Docker, AWS Batch and Airflow

## Getting started
We set up a gitpod environment containing all the tools required to complete this exercise (awscli, python, vscode, ...).
You can access this environment by clicking the button below:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/datamindedbe/academy-capstone)

Before you commence data crunching, set up your `.aws/credentials` file. This required to access AWS services through the API.
Run `aws configure` in the terminal and enter correct information:
```shell
AWS Access Key ID [None]: [YOUR_ACCESS_KEY]
AWS Secret Access Key [None]: [YOUR_SECRET_KEY]
Default region name [None]: eu-west-1
Default output format [None]: json
```
