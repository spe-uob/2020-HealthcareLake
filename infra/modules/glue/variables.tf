variable "lake_arn" {} 

variable "lake_name" {}

variable "name_prefix" {
  default = "FhirDb"
}

variable "prefix" {}

variable "fhir_db_name" {}

variable "fhir_db_arn" {}

// KMS for DynamoDB (arn)
variable "fhir_db_cmk" {} 

variable "glue_script_bucket_id" {}
variable "glue_script_path" {}
variable "glue_library_path" {}