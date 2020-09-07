variable "project" {
  description = "Project's name"
  type        = string
  default     = "falcon"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "sandbox"
}

variable "eks_version" {
  description = "EKS version"
  type        = string
  default     = "1.17"
}

variable "desired_size" {
  description = "Number of nodes"
  type        = string
  default     = 2
}

variable "max_size" {
  description = "Number max of nodes"
  type        = string
  default     = 4
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