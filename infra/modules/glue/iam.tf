/*
  IAM permissions for the glue crawler
*/
resource "aws_iam_role" "crawler_role" {
  name = "AWSGlueServiceRole-CrawlerRole"
  assume_role_policy = data.aws_iam_policy_document.glue_role_policy.json
}
resource "aws_iam_role" "job_role" {
  name = "AWSGlueServiceRole-JobRole"
  assume_role_policy = data.aws_iam_policy_document.glue_role_policy.json
}
data "aws_iam_policy_document" "glue_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "glue_policy" {
  statement {
    actions = ["iam:PassRole"]
    effect = "Allow"
    resources = [
      "arn:aws:iam::*:role/AWSGlueServiceRole*",
      "arn:aws:iam::*:role/service-role/AWSGlueServiceRole*"
    ]
    condition {
      test = "StringLike"
      variable = "iam:PassedToService"
      values = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "crawler_policy" {
  name = "AWSGlueServiceRole-Crawler"
  policy = data.aws_iam_policy_document.glue_policy.json
}
resource "aws_iam_policy" "job_policy" {
  name = "AWSGlueServiceRole-Job"
  policy = data.aws_iam_policy_document.glue_policy.json
}

// Crawler
resource "aws_iam_role_policy_attachment" "crawler_attachment" {
  role = aws_iam_role.crawler_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}
resource "aws_iam_role_policy_attachment" "glue_attachment_1" {
  role = aws_iam_role.crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
resource "aws_iam_role_policy_attachment" "glue_attachment_3" {
  role = aws_iam_role.crawler_role.name
  policy_arn = aws_iam_policy.crawler_policy.arn
}

// Job
resource "aws_iam_role_policy_attachment" "job_attachment_1" {
  role = aws_iam_role.job_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}
resource "aws_iam_role_policy_attachment" "job_attachment_2" {
  role = aws_iam_role.job_role.name
  policy_arn = aws_iam_policy.lake_write.arn
}
resource "aws_iam_role_policy_attachment" "job_attachment_3" {
  role = aws_iam_role.job_role.name
  policy_arn = aws_iam_policy.lib_read.arn
}
resource "aws_iam_role_policy_attachment" "glue_attachment_2" {
  role = aws_iam_role.job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
resource "aws_iam_role_policy_attachment" "job_attachment_4" {
  role = aws_iam_role.job_role.name
  policy_arn = aws_iam_policy.job_policy.arn
}

// DynamoDB access
resource "aws_iam_policy" "dynamodb_access" {
  name = "FHIR_DynamoDb_Access"
  policy = data.aws_iam_policy_document.dynamodb_access_policy.json
}
data "aws_iam_policy_document" "dynamodb_access_policy" {
  // Decrypt
  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      var.fhir_db_cmk
    ]
  }
  // Read DynamoDb
  statement {
    actions = [
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
    resources = [
      var.fhir_db_arn
    ]
  }
}

// S3 access
resource "aws_iam_policy" "lake_write" {
  name = "Lake_S3_Access"
  policy = data.aws_iam_policy_document.lake_write_policy.json
}
data "aws_iam_policy_document" "lake_write_policy" {
  // Read|Write to S3 lake
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]
    resources = [
      var.lake_arn,
      "${var.lake_arn}/*"
    ]
  }
}
resource "aws_iam_policy" "lib_read" {
  name = "PySpark_Lib_S3_Access"
  policy = data.aws_iam_policy_document.lib_read_policy.json
}
data "aws_iam_policy_document" "lib_read_policy" {
  statement {
    actions = [
    "s3:GetObject"
    ]
    resources = [
      var.etl_bucket_arn,
      "${var.etl_bucket_arn}/*"
    ]
  }
}