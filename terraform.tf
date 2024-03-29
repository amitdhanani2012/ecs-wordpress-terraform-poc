terraform {

  cloud {
    organization = "aws-amit"

    workspaces {
      name = "ecs-wordpress-amit"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42.0"
    }
  }

  required_version = ">= 1.1.0"
}
