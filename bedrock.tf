resource "aws_s3_bucket" "this" {
  count = var.enable_bedrock_log_export ? 1 : 0

  bucket = "attribute-logs-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_policy" "this" {
  count = var.enable_bedrock_log_export ? 1 : 0

  bucket = aws_s3_bucket.this[0].bucket

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "bedrock.amazonaws.com"
      },
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.this[0].arn}/*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
        },
        "ArnLike": {
          "aws:SourceArn": "arn:aws:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        }
      }
    }
  ]
}
EOF
}


resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  count = var.enable_bedrock_log_export ? 1 : 0

  depends_on = [
    aws_s3_bucket_policy.this
  ]

  logging_config {
    embedding_data_delivery_enabled = false
    image_data_delivery_enabled     = false
    text_data_delivery_enabled      = false

    s3_config {
      bucket_name = aws_s3_bucket.this[0].id
      key_prefix  = "bedrock-logs"
    }
  }
}
