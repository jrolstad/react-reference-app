resource "aws_s3_bucket_website_configuration" "example" {
  bucket = replace("${local.service_name}client","_","")

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}