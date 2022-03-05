# Create 3 digit random string
resource "random_string" "bootstrap_random_id" {
  length  = 3
  special = false
  upper   = false
}

# Concatenate with random string to avoid duplication
locals {
  aws_iam_role        = "${var.aws_iam_role}-${random_string.bootstrap_random_id.id}"
  aws_iam_role_policy = "${var.aws_iam_role_policy}-${random_string.bootstrap_random_id.id}"
  bootstrap_bucket    = "${var.bootstrap_bucket}-${var.aws_region}-${random_string.bootstrap_random_id.id}"
}

resource "aws_iam_role" "this" {
  name = local.aws_iam_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  name = local.aws_iam_role_policy
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${local.bootstrap_bucket}"
      },
      {
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${local.bootstrap_bucket}"
      },
    ]
  })
}

resource "aws_s3_bucket" "this" {
  bucket = local.bootstrap_bucket
  tags = {
    Name = local.bootstrap_bucket
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_object" "init_conf" {
  bucket = aws_s3_bucket.this.id
  key    = "init.conf"
  source = "./bootstrap/init.conf"
}