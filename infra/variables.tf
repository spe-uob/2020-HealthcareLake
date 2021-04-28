variable "region" {
  default = "eu-west-2"
}

variable "stage" {
  default = "dev"
}

variable "project_name" {
  default = "healthcarelake"

  validation {
    condition     = can(regex("^[a-z]+$", var.project_name))
    error_message = "The project_name must be all lowercase letters."
  }
}