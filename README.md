[![CircleCI](https://circleci.com/gh/spe-uob/HealthcareLake.svg?style=shield&circle-token=7e5cdbd8560954c827bd8e0368dc7785e6d788f0)](https://app.circleci.com/pipelines/github/spe-uob/HealthcareLake)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fspe-uob%2FHealthcareDataLake.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fspe-uob%2FHealthcareDataLake?ref=badge_shield)


# Healthcare Data Lake
This project is designed to explore the benefits of cloud technologies to produce a prototype secure, scalable health data storage platform that can underpin local healthcare analytics.

## Motivation
Digital healthcare provided by the NHS in England typically operates in silos. GPs have electronic systems to manage patient care which are distinct from hospital systems, the ambulance service, 111, mental health services etc. Each data owner has a wealth of data that, if combined, would generate a more valuable resource than it does in isolation. While there are solutions to integrate this data for direct care purposes, there is no centralised solution to use this data to inform future care or service provisioning.

## Documentation

You can read our docs [here](https://spe-uob.gitbook.io/healthcare-data-lake/).

## Usage

### Data Simulation Team

For instructions on integrating our production API, please see [this](https://spe-uob.gitbook.io/healthcare-data-lake/api/usage)

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

Deploy Terraform changes
```
terraform apply
```


(Optional) Destroy Terraform infrastructure
```
terraform destroy
```
