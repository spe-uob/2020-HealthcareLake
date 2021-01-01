output "bucket_id" {
  value = aws_s3_bucket.lake.id
}

output "bucket_arn" {
  value = aws_s3_bucket.lake.arn
}

output "logging_target_bucket" {
  value = tolist(aws_s3_bucket.lake.logging)[0].target_bucket
}