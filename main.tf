
terraform {
required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}
resource "aws_sns_topic" "topic" {
  name = var.name

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:name",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.bucket.arn}"}
        }
    }]
}
POLICY
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = var.bucket
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = var.bucket
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]

  }
}
