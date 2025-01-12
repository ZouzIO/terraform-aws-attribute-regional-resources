resource "random_uuid" "external_id" {}



module "attribute-regional-us-east-1" {
  source  = "ZouzIO/attribute-regional-resource/aws"
  version = "~> 1"

  enable_bedrock_log_export = true

  providers = {
    aws = aws.us-east-1
  }
}


module "attribute-regional-us-east-2" {
  source  = "ZouzIO/attribute-regional-resource/aws"
  version = "~> 1"

  enable_bedrock_log_export = true

  providers = {
    aws = aws.us-east-2
  }
}

module "attribute-sensor" {
  source  = "ZouzIO/attribute-sensor/aws"
  version = "~> 1.1"

  organization_id = var.organization_id
  deployment_id   = var.deployment_id
  deployment_name = var.deployment_name
  external_id     = random_uuid.external_id.id

  logs_export_buckets = [
    module.attribute-regional-us-east-1.bedrock_export_bucket_arn,
    module.attribute-regional-us-east-2.bedrock_export_bucket_arn
  ]
}
