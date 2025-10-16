/**
 * @fileoverview Variables for Grafana module
 * @author Terraform DevOps
 * @date 2025-01-15
 */

variable "network_name" {
  description = "Name of the Docker network"
  type        = string
}

# Grafana Authentication & Security
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

# Grafana Server Configuration
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

# Grafana User Management
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

# Grafana Features & Plugins
variable "grafana_plugins" {
  description = "Comma-separated list of plugins to preinstall"
  type        = string
  default     = "grafana-piechart-panel,grafana-clock-panel,grafana-simple-json-datasource"
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

# Grafana Analytics & Updates
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

# Grafana Logging
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

# Grafana Unified Alerting
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
