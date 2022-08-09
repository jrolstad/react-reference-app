resource "aws_s3_bucket" "client_app" {
  bucket = replace("${local.service_name}client","_","")
}

resource "aws_s3_bucket_website_configuration" "client_app" {
  bucket = aws_s3_bucket.client_app.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}