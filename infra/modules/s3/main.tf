
resource "aws_s3_bucket" "lake" {
  bucket = "${var.prefix}-lake"
  acl = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.prefix}-lake-logs"
  acl = "log-delivery-write"
}

data "aws_iam_policy_document" "lake_vpc" {
  statement {
    sid = "Access from subnet only"
    actions = ["s3:*"]
    resources = [aws_s3_bucket.lake.arn]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    condition {
      test = "IpAddress"
      variable = "aws:SourceIp"
      values = [var.lake_subnet]
    }
  }
}

resource "aws_s3_bucket_policy" "lake" {
  bucket = aws_s3_bucket.lake.id

  policy = data.aws_iam_policy_document.lake_vpc.json
}