terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.42.0"
    }
    
  }
  backend "s3"{
        bucket         = "roboshop-state-aws-terraform-88s"
        key            = "roboshop-dev-sg.tfstate"
        region         = "us-east-1"
        encrypt        = true
        use_lockfile   = true
  }
}

provider "aws" {
  region = "us-east-1"
}