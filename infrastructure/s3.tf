// Create S3 bucket to test ec2 iam instance profile

resource "aws_s3_bucket" "bucket" {
    bucket        = "${var.app_name}-${var.environment}-bucket"
    force_destroy = true
    acl           = "private"

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm     = "AES256"
            }
        }
    }

  
      tags = merge(
      var.additional_tags,
      {
          "Environment" = "${var.environment}"
          "Owner"       = "${var.owner}"
          "Region"      = "${var.region}"
      },
  )
}

# Block public access

resource "aws_s3_bucket_public_access_block" "s3_deny_public" {
  bucket = "${aws_s3_bucket.bucket.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Attach bucket policy

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = "${aws_s3_bucket.bucket.id}"
  
policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allow nessus Instance S3 full access",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_role.instance_role.arn}"
            },
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.bucket.arn}"
        }
    ]
}
EOT
}