/**
 * @fileoverview Variables for network module
 * @author Terraform DevOps
 * @date 2025-01-15
 */

variable "network_name" {
  description = "Name of the Docker network"
  type        = string
  default     = "observability_network"
}

variable "network_subnet" {
  description = "Subnet CIDR for the Docker network"
  type        = string
  default     = "172.20.0.0/16"
}
