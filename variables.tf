terraform {
  required_providers {
    aws = {
      version = "~> 2.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

variable "sender_email" {
  description = "The email address used to send emails from SES"
  type        = string
}

variable "s3_bucket" {
  description = "s3 bucket name"
  type        = string
}
