variable "region" {
  type = string
  default = "eu-west-2"
}

variable "stage" {
  type = string
  default = "dev"
}

variable "project_name" {
  type = string

  validation {
    condition     = can(regex("^[a-z]+$", var.project_name))
    error_message = "The project_name must be all lowercase letters."
  }
}