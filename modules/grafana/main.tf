/**
 * @fileoverview Grafana module for visualization
 * @author Terraform DevOps
 * @date 2025-01-15
 */

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Grafana server
resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name    = "grafana"
  image   = docker_image.grafana.name
  restart = "always"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 3000
    external = 3000
  }

  # Grafana configuration - showcasing Terraform environment variable management
  env = [
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}",
    "GF_USERS_ALLOW_SIGN_UP=${var.grafana_allow_signup}",
    "GF_PLUGINS_PREINSTALL=${var.grafana_plugins}",
    "GF_PROVISIONING_PATH=/etc/grafana/provisioning",
    "GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=${var.grafana_default_dashboard}",
    "GF_SECURITY_DISABLE_GRAVATAR=${var.grafana_disable_gravatar}",
    "GF_ANALYTICS_REPORTING_ENABLED=${var.grafana_analytics_reporting}",
    "GF_ANALYTICS_CHECK_FOR_UPDATES=${var.grafana_check_updates}",
    "GF_LOG_LEVEL=${var.grafana_log_level}",
    "GF_FEATURE_TOGGLES_ENABLE=${var.grafana_feature_toggles}",
    "GF_UNIFIED_ALERTING_ENABLED=${var.grafana_unified_alerting_enabled}",
    "GF_UNIFIED_ALERTING_MIN_INTERVAL=${var.grafana_alerting_min_interval}",
    "GF_UNIFIED_ALERTING_DEFAULT_RULE_EVALUATION_INTERVAL=${var.grafana_alerting_evaluation_interval}",
    "GF_SERVER_PROTOCOL=${var.grafana_protocol}",
    "GF_SERVER_HTTP_PORT=${var.grafana_port}",
    "GF_SERVER_DOMAIN=${var.grafana_domain}",
    "GF_SERVER_ROOT_URL=${var.grafana_root_url}",
    "GF_SERVER_SERVE_FROM_SUB_PATH=${var.grafana_serve_from_sub_path}",
    "GF_SECURITY_ADMIN_USER=${var.grafana_admin_user}",
    "GF_SECURITY_SECRET_KEY=${var.grafana_secret_key}",
    "GF_USERS_ALLOW_ORG_CREATE=${var.grafana_allow_org_create}",
    "GF_USERS_AUTO_ASSIGN_ORG=${var.grafana_auto_assign_org}",
    "GF_USERS_AUTO_ASSIGN_ORG_ROLE=${var.grafana_auto_assign_org_role}",
    "GF_LOG_MODE=${var.grafana_log_mode}"
  ]

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  # Datasource provisioning
  volumes {
    host_path      = "${abspath(path.module)}/../../config/grafana/datasources-simple.yml"
    container_path = "/etc/grafana/provisioning/datasources/datasources.yml"
  }

  # Dashboard provisioning
  volumes {
    host_path      = "${abspath(path.module)}/../../config/grafana/dashboards.yml"
    container_path = "/etc/grafana/provisioning/dashboards/dashboards.yml"
  }

  volumes {
    host_path      = "${abspath(path.module)}/../../config/grafana/"
    container_path = "/etc/grafana/provisioning/dashboards"
  }

  # Grafana main configuration
  volumes {
    host_path      = "${abspath(path.module)}/../../config/grafana/grafana.ini"
    container_path = "/etc/grafana/grafana.ini"
  }


  # Notification channels provisioning
  volumes {
    host_path      = "${abspath(path.module)}/../../config/grafana/notifiers.yml"
    container_path = "/etc/grafana/provisioning/notifiers/notifiers.yml"
  }
}

# Grafana data volume
resource "docker_volume" "grafana_data" {
  name = "grafana_data"
}
