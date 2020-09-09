module "ami" {
  source = "github.com/insight-infrastructure/terraform-aws-ami.git?ref=v0.1.0"
}

resource "aws_eip" "this" {
  count = var.create_superset ? 1 : 0
  tags  = var.tags
}

resource "aws_eip_association" "this" {
  count       = var.create_superset ? 1 : 0
  instance_id = join("", aws_instance.this.*.id)
  public_ip   = join("", aws_eip.this.*.public_ip)
}

resource "aws_key_pair" "this" {
  count      = var.public_key_path != "" && var.create_superset ? 1 : 0
  public_key = file(var.public_key_path)
  tags       = var.tags
}

resource "aws_instance" "this" {
  count = var.create_superset ? 1 : 0

  ami           = module.ami.ubuntu_1804_ami_id
  instance_type = var.instance_type

  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = compact(concat([join("", aws_security_group.this.*.id)], var.additional_security_groups))
  key_name               = var.public_key_path == "" ? var.key_name : join("", aws_key_pair.this.*.key_name)

  root_block_device {
    volume_size = var.root_volume_size
  }

  tags = var.tags
}

module "ansible" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.13.0"
  create = var.create_superset

  ip               = join("", aws_eip_association.this.*.public_ip)
  user             = "ubuntu"
  private_key_path = var.private_key_path

  playbook_file_path = "${path.module}/ansible/main.yml"
  playbook_vars = merge({
    superset_postgres_db_host     = var.create_rds ? module.db.this_db_instance_address : var.superset_postgres_db_host
    superset_postgres_db_port     = 5432
    superset_postgres_db_name     = var.superset_postgres_db_name
    superset_postgres_db_username = var.superset_postgres_db_username
    superset_postgres_db_password = var.superset_postgres_db_password

    enable_superset_local_postgres = ! var.create_rds
    enable_superset_nginx          = var.domain_name != "" && var.hostname != ""
    enable_superset_ssl            = var.domain_name != "" && var.hostname != ""

    fqdn = local.fqdn

    certbot_admin_email = local.certbot_admin_email
  }, var.playbook_vars)

  requirements_file_path = "${path.module}/ansible/requirements.yml"
}

locals {
  fqdn                = join(".", concat([var.hostname, var.domain_name]))
  certbot_admin_email = var.certbot_admin_email == "" ? "admin@${var.domain_name}" : var.certbot_admin_email
}