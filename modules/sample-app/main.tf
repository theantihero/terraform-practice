/**
 * @fileoverview Sample application module
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

# Use pre-built Node.js image instead of building
resource "docker_image" "sample_app" {
  name = "node:18-alpine"
}

# Sample application container 1
resource "docker_container" "sample_app_1" {
  name    = "sample-app-1"
  image   = docker_image.sample_app.name
  restart = "always"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 3000
    external = 3001
  }

  # Environment variables
  env = [
    "NODE_ENV=production",
    "PORT=3000",
    "INSTANCE_ID=app-1"
  ]

  # Mount application code
  volumes {
    host_path      = "${abspath(path.module)}/app.js"
    container_path = "/app/app.js"
  }

  volumes {
    host_path      = "${abspath(path.module)}/package.json"
    container_path = "/app/package.json"
  }

  # Mount log directory (create if doesn't exist)
  volumes {
    host_path      = "${abspath(path.module)}/../../logs"
    container_path = "/var/log/sample-app"
  }

  # Working directory and command
  working_dir = "/app"
  command     = ["sh", "-c", "npm install && node app.js"]

  # Health check
  healthcheck {
    test         = ["CMD", "node", "-e", "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"]
    interval     = "30s"
    timeout      = "3s"
    retries      = 3
    start_period = "30s"
  }
}

# Sample application container 2
resource "docker_container" "sample_app_2" {
  name    = "sample-app-2"
  image   = docker_image.sample_app.name
  restart = "always"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 3000
    external = 3002
  }

  # Environment variables
  env = [
    "NODE_ENV=production",
    "PORT=3000",
    "INSTANCE_ID=app-2"
  ]

  # Mount application code
  volumes {
    host_path      = "${abspath(path.module)}/app.js"
    container_path = "/app/app.js"
  }

  volumes {
    host_path      = "${abspath(path.module)}/package.json"
    container_path = "/app/package.json"
  }

  # Mount log directory (create if doesn't exist)
  volumes {
    host_path      = "${abspath(path.module)}/../../logs"
    container_path = "/var/log/sample-app"
  }

  # Working directory and command
  working_dir = "/app"
  command     = ["sh", "-c", "npm install && node app.js"]

  # Health check
  healthcheck {
    test         = ["CMD", "node", "-e", "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"]
    interval     = "30s"
    timeout      = "3s"
    retries      = 3
    start_period = "30s"
  }
}
