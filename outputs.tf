output "bedrock_export_bucket_arn" {
  value = var.enable_bedrock_log_export ? aws_s3_bucket.this[0].arn : ""
}
