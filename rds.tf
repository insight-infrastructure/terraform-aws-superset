locals {
  id = var.id == "" ? var.name : var.id
}


resource "aws_security_group" "rds" {
  count       = 1
  name        = var.name
  description = "Security group for ${var.name} superset vm"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group_rule" "rds_pg" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = join("", aws_security_group.rds.*.id)

  self = true
}

resource "aws_security_group_rule" "rds_public" {
  count             = var.rds_public_access ? 1 : 0
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = join("", aws_security_group.rds.*.id)

  cidr_blocks = ["0.0.0.0/0"]
}

module "db" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds?ref=master"

  identifier = local.id
  name       = var.name

  engine               = "postgres"
  engine_version       = "9.6.9"
  family               = "postgres9.6"
  major_engine_version = "9.6"

  instance_class = var.instance_class

  allocated_storage = 5
  storage_encrypted = false

  username = var.username
  password = var.password

  port = "5432"

  vpc_security_group_ids = [join("", aws_security_group.rds.*.id)]
  subnet_ids             = var.subnet_ids

  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  backup_retention_period = 0

  final_snapshot_identifier = local.id
  deletion_protection       = false

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = var.tags
}
