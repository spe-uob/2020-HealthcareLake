resource "aws_s3_bucket" "athena_queries_datalake" {
  bucket = "athena_queries_datalake"
}

resource "aws_athena_database" "athena_queries_datalake" {
  name   = "datalake_athena"
  bucket = aws_s3_bucket.athena_queries_datalake.bucket
}