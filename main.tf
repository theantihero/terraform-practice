/**
 * @fileoverview Main Terraform configuration for Grafana + Prometheus + Loki observability stack
 * @author Terraform DevOps
 * @date 2025-01-15
 */

terraform {
  required_version = ">= 1.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

# Network module
module "network" {
  source = "./modules/network"

  network_name   = var.network_name
  network_subnet = var.network_subnet
}

# Prometheus module
module "prometheus" {
  source = "./modules/prometheus"

  network_name = module.network.network_name

  depends_on = [module.network]
}

# Loki module
module "loki" {
  source = "./modules/loki"

  # Network configuration
  network_name = module.network.network_name

  # Loki server configuration
  loki_http_port = var.loki_http_port
  loki_grpc_port = var.loki_grpc_port
  loki_log_level = var.loki_log_level

  # Loki storage configuration
  loki_storage_path       = var.loki_storage_path
  loki_replication_factor = var.loki_replication_factor

  # Loki limits configuration
  loki_max_streams_per_user        = var.loki_max_streams_per_user
  loki_max_line_size               = var.loki_max_line_size
  loki_max_query_parallelism       = var.loki_max_query_parallelism
  loki_max_query_length            = var.loki_max_query_length
  loki_max_query_series            = var.loki_max_query_series
  loki_max_entries_limit_per_query = var.loki_max_entries_limit_per_query

  # Loki cache configuration
  loki_cache_max_size_items = var.loki_cache_max_size_items
  loki_cache_max_size_bytes = var.loki_cache_max_size_bytes
  loki_cache_validity       = var.loki_cache_validity

  # Loki analytics configuration
  loki_analytics_enabled = var.loki_analytics_enabled

  depends_on = [module.network]
}

# Grafana module
module "grafana" {
  source = "./modules/grafana"

  # Network configuration
  network_name = module.network.network_name

  # Grafana authentication & security
  grafana_admin_user     = var.grafana_admin_user
  grafana_admin_password = var.grafana_admin_password
  grafana_secret_key     = var.grafana_secret_key

  # Grafana server configuration
  grafana_protocol            = var.grafana_protocol
  grafana_port                = var.grafana_port
  grafana_domain              = var.grafana_domain
  grafana_root_url            = var.grafana_root_url
  grafana_serve_from_sub_path = var.grafana_serve_from_sub_path

  # Grafana user management
  grafana_allow_signup         = var.grafana_allow_signup
  grafana_allow_org_create     = var.grafana_allow_org_create
  grafana_auto_assign_org      = var.grafana_auto_assign_org
  grafana_auto_assign_org_role = var.grafana_auto_assign_org_role

  # Grafana features & plugins
  grafana_plugins           = var.grafana_plugins
  grafana_default_dashboard = var.grafana_default_dashboard
  grafana_feature_toggles   = var.grafana_feature_toggles

  # Grafana analytics & updates
  grafana_analytics_reporting = var.grafana_analytics_reporting
  grafana_check_updates       = var.grafana_check_updates
  grafana_disable_gravatar    = var.grafana_disable_gravatar

  # Grafana logging
  grafana_log_level = var.grafana_log_level
  grafana_log_mode  = var.grafana_log_mode

  # Grafana unified alerting
  grafana_unified_alerting_enabled     = var.grafana_unified_alerting_enabled
  grafana_alerting_min_interval        = var.grafana_alerting_min_interval
  grafana_alerting_evaluation_interval = var.grafana_alerting_evaluation_interval

  depends_on = [module.prometheus, module.loki]
}

# Sample application module
module "sample_app" {
  source = "./modules/sample-app"

  network_name = module.network.network_name

  depends_on = [module.network]
}