locals {
  mime_types = {
    "css"                 = "text/css"
    "html"                = "text/html"
    "ico"                 = "image/vnd.microsoft.icon"
    "js"                  = "application/javascript"
    "json"                = "application/json"
    "map"                 = "application/json"
    "png"                 = "image/png"
    "svg"                 = "image/svgxml"
    "txt"                 = "text/plain"
    "scss"                = "text/scss"
    "xml"                 = "text/xml"
    "spritemap"           = "image/svgxml"
    "woff"                = "font/woff"
    "woff2"               = "font/woff2"
    "less"                = "text/less"
    "ttf"                 = "font/ttf"
    "eot"                 = "font/eot"
    "otf"                 = "font/otf"
    "DS_Store"            = "application/octet-stream"
    "jpg"                 = "image/jpeg"
    "jpeg"                = "image/jpeg"
    "codekit"             = "application/octet-stream"
    "codekit3"            = "application/octet-stream"
    "icloud"              = "application/octet-stream"
    "yml"                 = "text/yaml"
    "fontawesome-webfont" = "application/octet-stream"
  }
}

resource "aws_s3_bucket" "cloudResume" {
  #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  #checkov:skip=CKV2_AWS_61: "Ensure that an S3 bucket has a lifecycle configuration"
  #checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"
  bucket = var.bucket_name
  policy = file("./policy.json")
}

resource "aws_s3_bucket_versioning" "cloudResumeVersioning" {
  #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  bucket = aws_s3_bucket.cloudResume.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "cloudResume_acl" {
  bucket = aws_s3_bucket.cloudResume.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "crConfig" {
  bucket = aws_s3_bucket.cloudResume.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_object" "websiteFolder" {
  #checkov:skip=CKV_AWS_186: "Ensure S3 bucket Object is encrypted by KMS using a customer managed Key (CMK)"
  bucket       = aws_s3_bucket.cloudResume.id
  for_each     = fileset("./cloud-resume/", "**/*.*")
  key          = "content/${each.key}"
  source       = "./cloud-resume/${each.key}"
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
  etag         = filemd5("./cloud-resume/${each.key}")

  depends_on = [
    aws_s3_bucket.cloudResume
  ]
}

