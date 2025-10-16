/**
 * @fileoverview Outputs for Grafana module
 * @author Terraform DevOps
 * @date 2025-01-15
 */

output "grafana_url" {
  description = "URL to access Grafana UI"
  value       = "http://localhost:3000"
}

output "grafana_admin_user" {
  description = "Grafana admin username"
  value       = "admin"
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = var.grafana_admin_password
  sensitive   = true
}
