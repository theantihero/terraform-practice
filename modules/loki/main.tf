/**
 * @fileoverview Loki module for log aggregation
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

# Loki server
resource "docker_image" "loki" {
  name = "grafana/loki:latest"
}

resource "docker_container" "loki" {
  name  = "loki"
  image = docker_image.loki.name
  restart = "always"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = var.loki_http_port
    external = var.loki_http_port
  }

  # Loki configuration through environment variables
  env = [
    "LOKI_HTTP_PORT=${var.loki_http_port}",
    "LOKI_GRPC_PORT=${var.loki_grpc_port}",
    "LOKI_LOG_LEVEL=${var.loki_log_level}",
    "LOKI_STORAGE_PATH=${var.loki_storage_path}",
    "LOKI_REPLICATION_FACTOR=${var.loki_replication_factor}",
    "LOKI_MAX_STREAMS_PER_USER=${var.loki_max_streams_per_user}",
    "LOKI_MAX_LINE_SIZE=${var.loki_max_line_size}",
    "LOKI_MAX_QUERY_PARALLELISM=${var.loki_max_query_parallelism}",
    "LOKI_MAX_QUERY_LENGTH=${var.loki_max_query_length}",
    "LOKI_MAX_QUERY_SERIES=${var.loki_max_query_series}",
    "LOKI_MAX_ENTRIES_LIMIT_PER_QUERY=${var.loki_max_entries_limit_per_query}",
    "LOKI_CACHE_MAX_SIZE_ITEMS=${var.loki_cache_max_size_items}",
    "LOKI_CACHE_MAX_SIZE_BYTES=${var.loki_cache_max_size_bytes}",
    "LOKI_CACHE_VALIDITY=${var.loki_cache_validity}",
    "LOKI_ANALYTICS_ENABLED=${var.loki_analytics_enabled}"
  ]

  volumes {
    host_path      = "${abspath(path.module)}/../../config/loki/loki.yml"
    container_path = "/etc/loki/local-config.yaml"
  }

  volumes {
    volume_name    = docker_volume.loki_data.name
    container_path = var.loki_storage_path
  }

  command = ["-config.file=/etc/loki/local-config.yaml", "-config.expand-env=true"]
}

# Promtail for log collection
resource "docker_image" "promtail" {
  name = "grafana/promtail:latest"
}

resource "docker_container" "promtail" {
  name  = "promtail"
  image = docker_image.promtail.name
  restart = "always"

  networks_advanced {
    name = var.network_name
  }

  volumes {
    host_path      = "${abspath(path.module)}/../../config/loki/promtail.yml"
    container_path = "/etc/promtail/config.yml"
  }

  volumes {
    host_path      = "/var/lib/docker/containers"
    container_path = "/var/lib/docker/containers"
    read_only      = true
  }

  volumes {
    host_path      = "/var/log"
    container_path = "/var/log"
    read_only      = true
  }

  command = ["-config.file=/etc/promtail/config.yml", "-config.expand-env=true"]

  depends_on = [docker_container.loki]
}

# Loki data volume
resource "docker_volume" "loki_data" {
  name = "loki_data"
}
