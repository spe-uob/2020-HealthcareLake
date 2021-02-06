/*
  IAM permissions for the glue crawler
*/
# resource "aws_iam_role" "fhir_glue_crawler_role" {
#   name = "${var.name_prefix}CrawlerRole"

#   assume_role_policy = data.aws_iam_policy_document.fhir_glue_crawler_policy_doc.json
# }

# data "aws_iam_policy_document" "fhir_glue_crawler_policy_doc" {
#   // ...TODO
#   statement {
#     actions = [
#       "dynamodb:DescribeTable",
#       "dynamodb:Scan"
#     ]

#     resources = [
#       var.fhir_db_arn,
#     ]
#   }

#   statement {
#     actions = [
#       "kms:DescribeKey",
#       "kms:Decrypt"
#     ]

#     resources = [
#       var.fhir_db_cmk
#     ]
#   }
# }

# resource "aws_iam_role" "fhir_glue_job_role" {
#   name = "${var.name_prefix}Role"

#   assume_role_policy = data.aws_iam_policy_document.fhir_glue_job_policy_doc.json
# }

# data "aws_iam_policy_document" "fhir_glue_job_policy_doc" {
#   // ...TODO
#   statement {
#     actions = [
#       "s3:PutObject",
#     ]

#     resources = [
#       var.lake_bucket
#     ]
#   }
# }