variable "environment" {
  description = "environment name"
  default     = "dev"
  type        = string
}

variable "project" {
  description = "project tag"
  type        = string
}

variable "name" {
  description = "allows for additional sub-project naming"
  default     = "main"
  type        = string
}

variable "vpc_id" {
  description = "vpc ID"
  type        = string
}
