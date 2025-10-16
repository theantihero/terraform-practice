/**
 * @fileoverview Outputs for Prometheus module
 * @author Terraform DevOps
 * @date 2025-01-15
 */

output "prometheus_url" {
  description = "URL to access Prometheus UI"
  value       = "http://localhost:9090"
}

output "cadvisor_url" {
  description = "URL to access cAdvisor UI"
  value       = "http://localhost:8081"
}

output "node_exporter_url" {
  description = "URL to access Node Exporter metrics"
  value       = "http://localhost:9100/metrics"
}
