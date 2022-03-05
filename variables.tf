variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "AWS region"
}

variable "aws_iam_role" {
  type        = string
  default     = "bootstrap-FortiGate-S3-role"
  description = "Bootstrap IAM role name"
}

variable "aws_iam_role_policy" {
  type        = string
  default     = "bootstrap-FortiGate-S3-policy"
  description = "Bootstrap IAM role policy"
}

variable "bootstrap_bucket" {
  type        = string
  default     = "fortigate-bootstrap-bucket"
  description = "Bootstrap S3 bucket name"
}