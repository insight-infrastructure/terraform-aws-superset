
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

variable "create_efs" {
  description = "Boolean to create EFS file system"
  type        = bool
  default     = true
}

##########
# Superset
##########
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

variable "superset_postgres_db_user" {
  description = "The db user"
  type        = string
  default     = "postgres"
}

variable "superset_postgres_db_pass" {
  description = "The password"
  type        = string
  default     = "postgres"
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

