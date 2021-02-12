variable "lake_bucket" {} 

variable "name_prefix" {
  default = "FhirDb"
}

variable "prefix" {}

variable "fhir_db_name" {}

variable "fhir_db_arn" {}

// KMS for DynamoDB (arn)
variable "fhir_db_cmk" {} 