### Global Variables

variable "aws_region" {
  description = "Default Region"
  default     = ""
}

variable "stack" {
  description = "Current Stack (dev/prod)"
  default     = ""
}

### Compute Specific

variable "remote_state_bucket" {
  description = "Remote State S3 Bucket Name"
  default     = ""
}

variable "remote_state_infra_key" {
  description = "Remote State S3 Infrastructure Key"
  default     = ""
}

variable "compute_instance_type" {
  description = "The type of EC2 instance"
  default     = ""
}

variable "compute_key_name" {
  description = "Compute RSA Key Pair Name"
  default     = ""
}

variable "compute_sda_size" {
  description = "Compute EBS - Root (SDA) Size"
  default     = ""
}

variable "compute_instance_tags" {
  type    = map(any)
  default = {}
}

