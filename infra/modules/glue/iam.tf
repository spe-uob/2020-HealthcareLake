/*
  IAM permissions for the glue crawler
*/
resource "aws_iam_role" "crawler_role" {
  name = "${var.name_prefix}CrawlerRole"
  assume_role_policy = data.aws_iam_policy_document.glue_role_policy.json
}
resource "aws_iam_role" "job_role" {
  name = "${var.name_prefix}JobRole"
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

// Crawler
resource "aws_iam_role_policy_attachment" "crawler_attachment" {
  role = aws_iam_role.crawler_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}
resource "aws_iam_role_policy_attachment" "glue_attachment_1" {
  role = aws_iam_role.crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
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
resource "aws_iam_role_policy_attachment" "glue_attachment_2" {
  role = aws_iam_role.job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
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