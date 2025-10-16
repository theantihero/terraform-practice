/**
 * @fileoverview Prometheus module for metrics collection
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

# Prometheus server
resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name    = "prometheus"
  image   = docker_image.prometheus.name
  restart = "always"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    host_path      = "${abspath(path.module)}/../../config/prometheus/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }

  volumes {
    host_path      = "${abspath(path.module)}/../../config/prometheus/alerts.yml"
    container_path = "/etc/prometheus/rules/alerts.yml"
  }

  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus",
    "--web.console.libraries=/etc/prometheus/console_libraries",
    "--web.console.templates=/etc/prometheus/consoles",
    "--storage.tsdb.retention.time=15d",
    "--web.enable-lifecycle"
  ]
}

# cAdvisor for container metrics
resource "docker_image" "cadvisor" {
  name = "gcr.io/cadvisor/cadvisor:latest"
}

resource "docker_container" "cadvisor" {
  name    = "cadvisor"
  image   = docker_image.cadvisor.name
  restart = "always"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 8080
    external = 8081
  }

  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }

  volumes {
    host_path      = "/var/run"
    container_path = "/var/run"
  }

  volumes {
    host_path      = "/sys"
    container_path = "/sys"
    read_only      = true
  }

  volumes {
    host_path      = "/var/lib/docker"
    container_path = "/var/lib/docker"
    read_only      = true
  }

  privileged = true
}

# Node Exporter for system metrics
resource "docker_image" "node_exporter" {
  name = "prom/node-exporter:latest"
}

resource "docker_container" "node_exporter" {
  name    = "node-exporter"
  image   = docker_image.node_exporter.name
  restart = "always"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 9100
    external = 9100
  }

  volumes {
    host_path      = "/proc"
    container_path = "/host/proc"
    read_only      = true
  }

  volumes {
    host_path      = "/sys"
    container_path = "/host/sys"
    read_only      = true
  }

  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }

  command = [
    "--path.procfs=/host/proc",
    "--path.rootfs=/rootfs",
    "--path.sysfs=/host/sys",
    "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)"
  ]
}

# Prometheus data volume
resource "docker_volume" "prometheus_data" {
  name = "prometheus_data"
}
