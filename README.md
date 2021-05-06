[![CircleCI](https://circleci.com/gh/spe-uob/HealthcareLake.svg?style=shield&circle-token=7e5cdbd8560954c827bd8e0368dc7785e6d788f0)](https://app.circleci.com/pipelines/github/spe-uob/HealthcareLake)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fspe-uob%2FHealthcareDataLake.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fspe-uob%2FHealthcareDataLake?ref=badge_shield)
[![Scan](https://github.com/spe-uob/HealthcareLake/workflows/Scan/badge.svg)](https://github.com/spe-uob/HealthcareLake/actions/workflows/scan.yml)


# HealthcareLake
This project is designed to explore the benefits of cloud technologies to produce a prototype secure, scalable health data storage platform that can underpin local healthcare analytics.

The repo contains a Terraform module for deploying an AWS data lake (`./infra/`). This imports two other modules:

- [HealthcareLakeAPI](https://github.com/spe-uob/HealthcareLakeAPI): API to receive data (FHIR)
- [HealthcareLakeETL](https://github.com/spe-uob/HealthcareLakeETL): Spark ETL job (FHIR→OMOP)

While the root module imports `infra/` and uses it once, multiple data lakes can be deployed as shown in [this](https://github.com/spe-uob/HealthcareLakeDemo) demo.

## Motivation
Digital healthcare provided by the NHS in England typically operates in silos. GPs have electronic systems to manage patient care which are distinct from hospital systems, the ambulance service, 111, mental health services etc. Each data owner has a wealth of data that, if combined, would generate a more valuable resource than it does in isolation. While there are solutions to integrate this data for direct care purposes, there is no centralised solution to use this data to inform future care or service provisioning.

## Documentation

You can read our docs [here](https://spe-uob.gitbook.io/healthcare-data-lake/).

## Usage

### Deployment

Initialise the modules
```
terraform init
```

Deploy Terraform changes
```
terraform apply
```

(Optional) Destroy Terraform infrastructure
```
terraform destroy
```
