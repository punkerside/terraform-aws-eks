variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "eks_version" {
  description = "EKS version"
  type        = string
  default     = "1.18"
}

variable "desired_size" {
  description = "Number of nodes"
  type        = string
  default     = 2
}

variable "max_size" {
  description = "Number max of nodes"
  type        = string
  default     = 8
}

variable "min_size" {
  description = "Number min of nodes"
  type        = string
  default     = 1
}

variable "instance_types" {
  description = "Instance types"
  type        = list(string)
  default     = ["r5a.large"]
}

variable "force_update_version" {
  description = "Force update version"
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "Disk size of nodes"
  type        = string
  default     = 80
}

variable "ami_type" {
  description = "Ami type of nodes"
  type        = string
  default     = "AL2_x86_64"
}

variable "subnet_private_ids" {
  description = "Ids of subnets private"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "Ids of subnets public"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Endpoint private access"
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Endpoint public access"
  type        = bool
  default     = true
}