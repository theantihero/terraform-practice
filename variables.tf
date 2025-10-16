/**
 * @fileoverview Global variables for observability stack
 * @author Terraform DevOps
 * @date 2025-01-15
 */

# Network Configuration
variable "network_name" {
  description = "Name of the Docker network for the observability stack"
  type        = string
  default     = "observability_network"
}

variable "network_subnet" {
  description = "Subnet CIDR for the Docker network"
  type        = string
  default     = "172.20.0.0/16"
}

# Docker Configuration
variable "docker_host" {
  description = "Docker daemon host to connect to"
  type        = string
  default     = "npipe:////./pipe/docker_engine"
}

# Project Configuration
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-observability"
}

# Grafana Configuration
variable "grafana_admin_user" {
  description = "Admin username for Grafana"
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "grafana_secret_key" {
  description = "Secret key for Grafana security"
  type        = string
  default     = "SW2YcwTIb9zpOOhoPsMm"
  sensitive   = true
}

variable "grafana_protocol" {
  description = "Protocol for Grafana server"
  type        = string
  default     = "http"
  validation {
    condition     = contains(["http", "https"], var.grafana_protocol)
    error_message = "Protocol must be either 'http' or 'https'."
  }
}

variable "grafana_port" {
  description = "Port for Grafana server"
  type        = number
  default     = 3000
}

variable "grafana_domain" {
  description = "Domain for Grafana server"
  type        = string
  default     = "localhost"
}

variable "grafana_root_url" {
  description = "Root URL for Grafana server"
  type        = string
  default     = "http://localhost:3000/"
}

variable "grafana_serve_from_sub_path" {
  description = "Serve Grafana from sub path"
  type        = bool
  default     = false
}

variable "grafana_allow_signup" {
  description = "Allow user signup"
  type        = bool
  default     = false
}

variable "grafana_allow_org_create" {
  description = "Allow organization creation"
  type        = bool
  default     = false
}

variable "grafana_auto_assign_org" {
  description = "Auto assign organization"
  type        = bool
  default     = true
}

variable "grafana_auto_assign_org_role" {
  description = "Auto assign organization role"
  type        = string
  default     = "Viewer"
  validation {
    condition     = contains(["Viewer", "Editor", "Admin"], var.grafana_auto_assign_org_role)
    error_message = "Role must be one of: Viewer, Editor, Admin."
  }
}

variable "grafana_plugins" {
  description = "Comma-separated list of plugins to preinstall"
  type        = string
  default     = ""
}

variable "grafana_default_dashboard" {
  description = "Path to default dashboard"
  type        = string
  default     = "/etc/grafana/provisioning/dashboards/complete-observability-dashboard.json"
}

variable "grafana_feature_toggles" {
  description = "Comma-separated list of feature toggles to enable"
  type        = string
  default     = "ngalert"
}

variable "grafana_analytics_reporting" {
  description = "Enable analytics reporting"
  type        = bool
  default     = false
}

variable "grafana_check_updates" {
  description = "Check for updates"
  type        = bool
  default     = false
}

variable "grafana_disable_gravatar" {
  description = "Disable Gravatar"
  type        = bool
  default     = true
}

variable "grafana_log_level" {
  description = "Log level for Grafana"
  type        = string
  default     = "info"
  validation {
    condition     = contains(["debug", "info", "warn", "error"], var.grafana_log_level)
    error_message = "Log level must be one of: debug, info, warn, error."
  }
}

variable "grafana_log_mode" {
  description = "Log mode for Grafana"
  type        = string
  default     = "console"
  validation {
    condition     = contains(["console", "file", "syslog"], var.grafana_log_mode)
    error_message = "Log mode must be one of: console, file, syslog."
  }
}

variable "grafana_unified_alerting_enabled" {
  description = "Enable unified alerting"
  type        = bool
  default     = true
}

variable "grafana_alerting_min_interval" {
  description = "Minimum interval for alerting"
  type        = string
  default     = "10s"
}

variable "grafana_alerting_evaluation_interval" {
  description = "Default rule evaluation interval"
  type        = string
  default     = "15s"
}

# Loki Configuration
variable "loki_http_port" {
  description = "HTTP port for Loki server"
  type        = number
  default     = 3100
}

variable "loki_grpc_port" {
  description = "gRPC port for Loki server"
  type        = number
  default     = 9096
}

variable "loki_log_level" {
  description = "Log level for Loki server"
  type        = string
  default     = "info"
  validation {
    condition     = contains(["debug", "info", "warn", "error"], var.loki_log_level)
    error_message = "Log level must be one of: debug, info, warn, error."
  }
}

variable "loki_storage_path" {
  description = "Storage path for Loki data"
  type        = string
  default     = "/loki"
}

variable "loki_replication_factor" {
  description = "Replication factor for Loki"
  type        = number
  default     = 1
}

variable "loki_max_streams_per_user" {
  description = "Maximum streams per user"
  type        = number
  default     = 0
}

variable "loki_max_line_size" {
  description = "Maximum line size in bytes"
  type        = number
  default     = 256000
}

variable "loki_max_query_parallelism" {
  description = "Maximum query parallelism"
  type        = number
  default     = 32
}

variable "loki_max_query_length" {
  description = "Maximum query length"
  type        = string
  default     = "721h"
}

variable "loki_max_query_series" {
  description = "Maximum query series"
  type        = number
  default     = 500
}

variable "loki_max_entries_limit_per_query" {
  description = "Maximum entries limit per query"
  type        = number
  default     = 5000
}

variable "loki_cache_max_size_items" {
  description = "Maximum cache size in items"
  type        = number
  default     = 1024
}

variable "loki_cache_max_size_bytes" {
  description = "Maximum cache size in bytes"
  type        = number
  default     = 102400
}

variable "loki_cache_validity" {
  description = "Cache validity period"
  type        = string
  default     = "24h"
}

variable "loki_analytics_enabled" {
  description = "Enable analytics reporting"
  type        = bool
  default     = false
}

# Sample Application Configuration
variable "sample_app_instances" {
  description = "Number of sample application instances"
  type        = number
  default     = 2
  validation {
    condition     = var.sample_app_instances >= 1 && var.sample_app_instances <= 10
    error_message = "Number of instances must be between 1 and 10."
  }
}

variable "sample_app_port_start" {
  description = "Starting port for sample applications"
  type        = number
  default     = 3001
}