data "aws_iam_policy_document" "lake_vpc" {
  statement {
    sid       = "Access from subnet only"
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.lake.arn]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = [var.lake_subnet]
    }
  }
}

