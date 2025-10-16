/**
 * @fileoverview Outputs for observability stack
 * @author Terraform DevOps
 * @date 2025-01-15
 */

output "grafana_url" {
  description = "URL to access Grafana dashboard"
  value       = module.grafana.grafana_url
}

output "grafana_admin_user" {
  description = "Grafana admin username"
  value       = module.grafana.grafana_admin_user
}

output "prometheus_url" {
  description = "URL to access Prometheus"
  value       = module.prometheus.prometheus_url
}

output "loki_url" {
  description = "URL to access Loki"
  value       = module.loki.loki_url
}

output "sample_app_urls" {
  description = "URLs to access sample applications"
  value = {
    app_1 = module.sample_app.sample_app_1_url
    app_2 = module.sample_app.sample_app_2_url
    metrics = module.sample_app.sample_app_metrics_url
  }
}

output "network_name" {
  description = "Name of the Docker network"
  value       = module.network.network_name
}

output "stack_summary" {
  description = "Summary of deployed observability stack"
  value = {
    grafana_url = module.grafana.grafana_url
    prometheus_url = module.prometheus.prometheus_url
    loki_url = module.loki.loki_url
    sample_app_1 = module.sample_app.sample_app_1_url
    sample_app_2 = module.sample_app.sample_app_2_url
    grafana_admin_user = module.grafana.grafana_admin_user
    cadvisor_url = module.prometheus.cadvisor_url
  }
}
