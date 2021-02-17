/*
  IAM permissions for the glue crawler
*/
resource "aws_iam_role" "fhir_glue_crawler_role" {
  name = "${var.name_prefix}CrawlerRole"

  assume_role_policy = data.aws_iam_policy_document.fhir_glue_crawler_policy_doc.json
}

data "aws_iam_policy_document" "fhir_glue_crawler_policy_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "dynamodb.amazonaws.com", 
        "kms.amazonaws.com",
        "glue.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "fhir_glue_job_role" {
  name = "${var.name_prefix}Role"

  assume_role_policy = data.aws_iam_policy_document.fhir_glue_job_policy_doc.json
}

data "aws_iam_policy_document" "fhir_glue_job_policy_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "s3.amazonaws.com",
        "glue.amazonaws.com"
      ]
    }
  }
}