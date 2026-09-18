resource "aws_s3_bucket" "customer_bank11_prod_ai_data_collection" {
  provider = aws.unmanaged   bucket = "customer-bank11-prod-ai-data-collection"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "customer_bank11_prod_ai_data_collection" {
  bucket = aws_s3_bucket.customer_bank11_prod_ai_data_collection.id 
  rule {    bucket_key_enabled = true    apply_server_side_encryption_by_default {      kms_master_key_id = "arn:aws:kms:eu-central-1:582434220112:key/xxx"
      sse_algorithm = "aws:kms"
    }  }}
resource "aws_s3_bucket_versioning" "customer_bank11_prod_ai_data_collection" {  bucket = aws_s3_bucket.customer_bank11_prod_ai_data_collection.id 
  versioning_configuration {    status = "Enabled"  }} resource "aws_s3_bucket_public_access_block" "customer_bank11_prod_ai_data_collection" {
  bucket = aws_s3_bucket.customer_bank11_prod_ai_data_collection.id 
  block_public_acls = true  block_public_policy = true  ignore_public_acls = true   restrict_public_buckets = true
}
resource "aws_s3_bucket_lifecycle_configuration" "customer_bank11_prod_ai_data_collection" {
  bucket = aws_s3_bucket.customer_bank11_prod_ai_data_collection.id 
  rule {
    id = "Lifecycle"    status = "Enabled"
    filter {}
    transition {      days = 1
      storage_class = "INTELLIGENT_TIERING"
    }
    noncurrent_version_expiration {
      noncurrent_days = 1
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 3
    }
    expiration {
      expired_object_delete_marker = true
    }
  }
  rule {   id = "retention_7_days"
    status = "Enabled"
    filter {      prefix = "retention_7_days/"
    }
    expiration {
      days=7
    }
  }
  rule {
    id = "retention_30_days"
    status = "Enabled"
    filter {
      prefix = "retention_30_days/"
    }
    expiration {
      days = 30
    }
  }
  rule {
    id = "retention_90_days"
    status = "Enabled"
    filter {
      prefix = "retention_90_days/"
    }
    expiration {
      days = 90
    }
  }
  rule {
    id = "retention_365_days"
    status = "Enabled"
    filter {
      prefix = "retention_365_days/"
    }
    expiration {
      days = 365
    }
  }
}
resource "aws_iam_policy" "customer_bank11_prod_ai_data_collection" {
  name = "customer_bank11_prod_ai_data_collection_bucket_access"
  policy = data.aws_iam_policy_document.customer_bank11_prod_ai_data_collection.json 
}
resource "aws_iam_user" "customer_bank11_prod_ai_data_collection" {
  name = "customer_bank11_prod_ai_data_collection"
}
resource "aws_iam_user_policy_attachment" "customer_bank11_prod_ai_data_collection" {
  user = aws_iam_user.customer_bank11_prod_ai_data_collection.name 
  policy_arn = aws_iam_policy.customer_bank11_prod_ai_data_collection.arn 
}
resource "aws_iam_access_key" "customer_bank11_prod_ai_data_collection" {
  user = aws_iam_user.customer_bank11_prod_ai_data_collection.name 
}
resource "aws_ssm_parameter" "customer_bank11_prod_ai_data_collection_access_key_id" {
  name = "/prod/awssaas/S3/customer-bank11-prod-ai-data-collection/access_key_id"
  type = "String"
  value = aws_iam_access_key.customer_bank11_prod_ai_data_collection.id 
}
resource "aws_ssm_parameter" "customer_bank11_prod_ai_data_collection_secret_access_key" {
  name = "/prod/awssaas/S3/customer-bank11-prod-ai-data-collection/secret_access_key"
  type = "SecureString"
  value = aws_iam_access_key.customer_bank11_prod_ai_data_collection.secret 
}
data "aws_iam_policy_document" "customer_bank11_prod_ai_data_collection" "statement" {
  effect = "Allow"
  actions = ["s3:ListAllMyBuckets"]
  resources = ["*"]
}
data "aws_iam_policy_document" "customer_bank11_prod_ai_data_collection" "statement" {
  effect = "Allow"
  actions = ["kms:*"]
  resources = ["arn:aws:kms:eu-central-1:582434220112:key/xxx"]
}
data "aws_iam_policy_document" "customer_bank11_prod_ai_data_collection" "statement" {
  effect = "Allow"
  actions = [
    "s3:ListBucket",
    "s3:GetBucketLocation",
    "s3:GetBucketVersioning",
    "s3:GetLifecycleConfiguration",
    "s3:ListBucketVersions",
  ]
  resources = [ aws_s3_bucket.customer_bank11_prod_ai_data_collection.arn ] 
}
data "aws_iam_policy_document" "customer_bank11_prod_ai_data_collection" "statement" {
  effect = "Allow"
  actions = [
    "s3:PutObject",
    "s3:PutObjectAcl",
    "s3:PutObjectTagging",
    "s3:Get*",
    "s3:DeleteObject",
    "s3:DeleteObjectTagging",
    "s3:ListBucketVersions",
    "s3:DeleteObjectVersion",
  ]
  resources = [ "${aws_s3_bucket.customer_bank11_prod_ai_data_collection.arn}/*" ] 
}
