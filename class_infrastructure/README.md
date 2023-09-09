# Capstone infrastructure

This folder contains the infrastructure needed for the Capstone project. In its current state, the infrastructure assumes that there exists an `academy-class` group with admin permissions(?) in AWS, containing the participants. Historically, this group was provided by the infrastructure code of the Terraform course in the  `instructor_setup` [repo](https://github.com/datamindedacademy/instructor_setups). At some point, this should be refactored so that the capstone infrastructure does not have external dependencies.

Steps:

1. Apply the infrastructure in the `bootstrap` folder. This contains a AWS Secrets Manager secret for the password of the `TERRAFORM_ADMIN` user in Snowflake (refresh this secret in Snowflake, if needed), as well as an S3 bucket which will be used for storing Airflow DAGs and data
2. After making sure that the secret in Secrets Manager is populated with valid Snowflake credentials, apply the infrastructure in the latest Capstone infrastructure environment (e.g. `winter_2023`). TODO: refactor so that only a single environment is used. Keeping old versions is why we use Git.

WARNING: the creation of the Managed Workflows for Apache Airflow can take some time (up to 30 minutes).
