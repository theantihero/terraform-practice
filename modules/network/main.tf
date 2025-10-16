/**
 * @fileoverview Network module for Docker containers
 * @author Terraform DevOps
 * @date 2025-01-15
 */

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Docker network for observability stack
resource "docker_network" "observability_network" {
  name = var.network_name

  # Enable IPAM for custom subnet
  ipam_config {
    subnet = var.network_subnet
  }
}
