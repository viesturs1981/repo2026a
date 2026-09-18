resource "aws_s3_bucket" "customer_bank11_prod_ai_data_collection" {
  provider = aws.unmanaged
  bucket   = "customer-bank11-prod-ai-data-collection"

}
