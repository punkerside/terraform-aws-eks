variable "name" {
  type    = string
  default = null
}

variable "eks_version" {
  type    = string
  default = "1.27"
}

variable "desired_size" {
  type    = string
  default = 2
}

variable "max_size" {
  type    = string
  default = 4
}

variable "min_size" {
  type    = string
  default = 1
}

variable "instance_types" {
  type    = list(string)
  default = ["r5a.large"]
}

variable "force_update_version" {
  type    = bool
  default = false
}

variable "disk_size" {
  type    = string
  default = 120
}

variable "ami_type" {
  type    = string
  default = "AL2_x86_64"
}

variable "capacity_type" {
  type    = string
  default = "SPOT"
}

variable "subnet_private_ids" {
  type = list(string)
}

variable "subnet_public_ids" {
  type = list(string)
}

variable "endpoint_private_access" {
  type    = bool
  default = false
}

variable "endpoint_public_access" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}