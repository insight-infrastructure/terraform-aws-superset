output "public_ip" {
  value       = join("", aws_eip.this.*.public_ip)
  description = "The public IP of the instance created"
}

output "instance_id" {
  value       = join("", aws_instance.this.*.id)
  description = "The instance ID created"
}

output "key_name" {
  value       = join("", aws_key_pair.this.*.key_name)
  description = "The key pair name created"
}

output "rds_security_group" {
  value = join("", aws_security_group.rds.*.id)
}

output "db_instance_name" {
  value = module.db.this_db_instance_name
}

output "db_instance_address" {
  value = module.db.this_db_instance_address
}

output "db_instance_username" {
  value = module.db.this_db_instance_username
}

output "db_instance_endpoint" {
  value = module.db.this_db_instance_endpoint
}
