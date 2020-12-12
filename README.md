[![CircleCI](https://circleci.com/gh/spe-uob/HealthcareDataLake.svg?style=shield&circle-token=7e5cdbd8560954c827bd8e0368dc7785e6d788f0)](https://app.circleci.com/pipelines/github/spe-uob/HealthcareLakeRepo)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fspe-uob%2FHealthcareLakeRepo.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fspe-uob%2FHealthcareLakeRepo?ref=badge_shield)

# Healthcare Data Lake
This project is designed to explore the benefits of cloud technologies to produce a prototype secure, scalable health data storage platform that can underpin local healthcare analytics.

## Motivation
Digital healthcare provided by the NHS in England typically operates in silos. GPs have electronic systems to manage patient care which are distinct from hospital systems, the ambulance service, 111, mental health services etc. Each data owner has a wealth of data that, if combined, would generate a more valuable resource than it does in isolation. While there are solutions to integrate this data for direct care purposes, there is no centralised solution to use this data to inform future care or service provisioning.

## Documentation

[API](https://documenter.getpostman.com/view/12190139/TVsoFVgc)

[Solution architecture](../main/docs/solution-architecture.pdf)

## Usage

### Data Simulation Team

[FHIR API](../main/api/README.md)

### Data Lake Team

#### API
Change into the API directory
```
cd api
```
Run the deployment
```
sls deploy
```
(Optional) Destroy the deployment
```
sls remove
```

#### Data lake
Change into the infra directory
```
cd infra
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
(Optional) Destroy Terraform infrastructure
```
terraform destroy
```
