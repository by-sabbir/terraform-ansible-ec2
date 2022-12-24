terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region = var.region
}

module "ec2-bastion" {
  source = "./module/ec2"
}

module "sshkey" {
  source = "./module/sshkey"
}