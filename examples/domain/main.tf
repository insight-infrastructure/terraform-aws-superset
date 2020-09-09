variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

variable "private_key_path" {}
variable "public_key_path" {}
variable "domain_name" {}
variable "hostname" {}

module "default_vpc" {
  source = "github.com/insight-infrastructure/terraform-aws-default-vpc.git?ref=v0.1.0"
}

resource "aws_security_group" "this" {
  vpc_id = module.default_vpc.vpc_id

  dynamic "ingress" {
    for_each = [
      22,   #
      80,   #
      443,  #
      8088, # superset default
      9100, # node exporter
      9113, # nginx exporter - TODO: Needs nginx.conf overview
      9115, # blackbox exporter
      8080, # cadvisor
    ]

    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [
      "0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}

resource "random_pet" "this" {
  length = 2
}

module "defaults" {
  source = "../.."

  name = random_pet.this.id

  domain_name = var.domain_name
  hostname    = var.hostname

  private_key_path      = var.private_key_path
  public_key_path       = var.public_key_path
  create_security_group = false


  vpc_id                 = module.default_vpc.vpc_id
  subnet_ids             = module.default_vpc.subnet_ids
  vpc_security_group_ids = [aws_security_group.this.id]
}
