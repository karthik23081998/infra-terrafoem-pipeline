terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.19.0"
    }
  }

backend "s3" {
    bucket = "bhanu-2000-usa"
    key = "jp/infraterrfaorm"
    region = "ap-south-1"
}

}
provider "aws" {
    region = "ap-south-1"
  
}