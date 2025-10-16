/**
 * @fileoverview Outputs for network module
 * @author Terraform DevOps
 * @date 2025-01-15
 */

output "network_id" {
  description = "ID of the Docker network"
  value       = docker_network.observability_network.id
}

output "network_name" {
  description = "Name of the Docker network"
  value       = docker_network.observability_network.name
}
