
variable "id" {
  description = "The id to give to rds db, falls back to name"
  type        = string
  default     = ""
}

variable "name" {
  description = "A unique name to give all the resources"
  type        = string
  default     = "superset"
}

variable "tags" {
  description = "Tags to attach to all resources"
  type        = map(string)
  default     = {}
}

variable "create_rds" {
  description = "Boolean to create EFS file system"
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "Bool to create security group"
  type        = bool
  default     = true
}

#####
# SGs
#####
variable "ssh_ips" {
  description = "IPv4 address list to res"
  type        = list(string)
  default     = null
}

variable "open_ports" {
  description = "List of ports to open publicly"
  type        = list(string)
  default     = ["80", "443", "22"]
}

variable "additional_security_groups" {
  description = "List of additional security groups"
  type        = list(string)
  default     = []
}

##########
# Superset
##########
variable "create_superset" {
  description = "Bool to create superset"
  type        = bool
  default     = true
}

variable "superset_postgres_db_host" {
  description = "The db host - blank for using defaults"
  type        = string
  default     = ""
}

variable "superset_postgres_db_name" {
  description = "the db name"
  type        = string
  default     = "postgres"
}

variable "superset_postgres_db_username" {
  description = "The db user"
  type        = string
  default     = "postgres"
}

variable "superset_postgres_db_password" {
  description = "The password"
  type        = string
  default     = "postgres"
}

variable "enable_superset_nginx" {
  description = "Bool to enable nginx"
  type        = bool
  default     = false
}

variable "enable_superset_ssl" {
  description = "Bool to enable ssl cert - must activate enable_superset_nginx"
  type        = bool
  default     = false
}

#####
# DNS
#####
variable "create_dns" {
  description = "Bool to create dns record"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The domain name"
  type        = string
  default     = ""
}

variable "hostname" {
  description = "The hostname - ie hostname.example.com"
  type        = string
  default     = ""
}

variable "certbot_admin_email" {
  description = "Admin email for SSL cert - must be in same domain"
  type        = string
  default     = ""
}

######
# Data
######
variable "vpc_id" {
  description = "The vpc to deploy into"
  type        = string
}

variable "subnet_ids" {
  description = "The id of the subnet"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security groups"
  type        = list(string)
  default     = []
}

#####
# ec2
#####
variable "key_name" {
  description = "The key pair to import"
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Root volume size"
  type        = string
  default     = 8
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.medium"
}

variable "public_key_path" {
  description = "The path to the public ssh key"
  type        = string
}

variable "private_key_path" {
  description = "The path to the private ssh key"
  type        = string
}

variable "playbook_vars" {
  description = "Extra vars to include, can be hcl or json"
  type        = map(string)
  default     = {}
}


#####
# RDS
#####
variable "rds_public_access" {
  description = "Bool to allow public access to rds"
  type        = string
  default     = true
}

variable "instance_class" {
  description = "instance class for DB"
  type        = string
  default     = "db.t3.small"
}

//variable "subnet_ids" {
//  description = "The subnet ids for deployment"
//  type        = list(string)
//}

variable "username" {
  description = "Default username"
  type        = string
  default     = "icon"
}

variable "password" {
  description = "The password to default user"
  type        = string
  default     = "changemenow"
}

variable "maintenance_window" {
  description = "The time to perform maintenance"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "The window to be backing up the db during"
  type        = string
  default     = "03:00-06:00"
}
