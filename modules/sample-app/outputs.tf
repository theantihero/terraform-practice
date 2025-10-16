/**
 * @fileoverview Outputs for sample application module
 * @author Terraform DevOps
 * @date 2025-01-15
 */

output "sample_app_1_url" {
  description = "URL to access sample application instance 1"
  value       = "http://localhost:3001"
}

output "sample_app_2_url" {
  description = "URL to access sample application instance 2"
  value       = "http://localhost:3002"
}

output "sample_app_metrics_url" {
  description = "URL to access sample application metrics"
  value       = "http://localhost:3001/metrics"
}
