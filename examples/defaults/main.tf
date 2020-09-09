variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

variable "private_key_path" {}
variable "public_key_path" {}

module "default_vpc" {
  source = "github.com/insight-infrastructure/terraform-aws-default-vpc.git?ref=v0.1.0"
}

resource "random_pet" "this" {
  length = 2
}

module "defaults" {
  source = "../.."
  name   = random_pet.this.id

  private_key_path = var.private_key_path
  public_key_path  = var.public_key_path

  vpc_id     = module.default_vpc.vpc_id
  subnet_ids = module.default_vpc.subnet_ids
}
