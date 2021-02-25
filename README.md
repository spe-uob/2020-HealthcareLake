[![CircleCI](https://circleci.com/gh/spe-uob/HealthcareLake.svg?style=shield&circle-token=7e5cdbd8560954c827bd8e0368dc7785e6d788f0)](https://app.circleci.com/pipelines/github/spe-uob/HealthcareLake)
[![codecov](https://codecov.io/gh/spe-uob/HealthcareDataLake/branch/main/graph/badge.svg?token=5NU3R4PGRU)](https://codecov.io/gh/spe-uob/HealthcareDataLake)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fspe-uob%2FHealthcareDataLake.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fspe-uob%2FHealthcareDataLake?ref=badge_shield)


# Healthcare Data Lake
This project is designed to explore the benefits of cloud technologies to produce a prototype secure, scalable health data storage platform that can underpin local healthcare analytics.

## Motivation
Digital healthcare provided by the NHS in England typically operates in silos. GPs have electronic systems to manage patient care which are distinct from hospital systems, the ambulance service, 111, mental health services etc. Each data owner has a wealth of data that, if combined, would generate a more valuable resource than it does in isolation. While there are solutions to integrate this data for direct care purposes, there is no centralised solution to use this data to inform future care or service provisioning.

## Documentation

[API](https://documenter.getpostman.com/view/12190139/TVsoFVgc)

[Whitepaper](../main/docs/solution-architecture.pdf)

## Architecture

![v1](../main/docs/images/v1.png)

## Usage

### Data Simulation Team

[FHIR API](../main/api/README.md)

### Deployment

Change into the infra directory
```
cd infra
```

You may wish to save your project settings in a `.tfvars` file:

_**infra/terraform.tfvars**_
```tf
// aws region
region = "eu-west-2"

// must be unique
prefix = "healthcarelake"
```

Initialise the modules
```
terraform init
```

Select `dev` workspace
```
terraform workspace select dev
```
Run Terraform plan
```
terraform plan
```
Deploy Terraform changes
```
terraform apply
```
Copy the ETL script to the glue scripts bucket (Terraform output variable)
```shell
aws s3 cp jobs/lake_ingestion.py s3://GLUE_SCRIPTS/lake_ingestion.py
```


(Optional) Destroy Terraform infrastructure
```
terraform destroy
```
