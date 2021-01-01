package main

do_not_delete = [
  "aws_s3_bucket.lake",
  "aws_s3_bucket.log_bucket"
]

deny[msg] {
  check_delete_protected(input.resource_changes, do_not_delete)
  msg = "Terraform plan will delete a protected resource"
}