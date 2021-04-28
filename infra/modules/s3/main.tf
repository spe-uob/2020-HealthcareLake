/*
  The 'Lake' is an S3 bucket with our
  Parquet files stored in
*/
resource "aws_s3_bucket" "lake" {
  bucket_prefix = "${var.prefix}-lake"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket_prefix = "${var.prefix}-lake-logs"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "lake" {
  bucket = aws_s3_bucket.lake.id

  policy = data.aws_iam_policy_document.lake_vpc.json
}