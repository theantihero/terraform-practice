# Terraform Showcase

This project demonstrates Terraform best practices for infrastructure management and observability.

## Features

- **Modular Design**: Reusable modules for each component
- **Configuration Management**: Environment variables and config files
- **Container Orchestration**: Docker containers with proper networking
- **Monitoring Stack**: Grafana, Prometheus, Loki
- **CI/CD**: GitHub Actions workflows

## Modules

```
modules/
├── network/      # Docker network
├── prometheus/   # Metrics collection
├── loki/         # Log aggregation
├── grafana/      # Dashboards
└── sample-app/   # Test applications
```

## Key Terraform Concepts

- Environment variables for configuration
- Volume mounts for persistent data
- Health checks for containers
- Custom Docker networks
- Variable validation
- **Terraform Destroy**: Cleanup automation

## Module Examples

**Network Module:**
```hcl
resource "docker_network" "observability_network" {
  name = var.network_name
  ipam_config {
    subnet = var.network_subnet
  }
}
```

**Container with Environment Variables:**
```hcl
resource "docker_container" "grafana" {
  env = [
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}",
    "GF_PLUGINS_PREINSTALL=${var.grafana_plugins}"
  ]
  
  volumes {
    host_path      = "${abspath(path.module)}/../../config/grafana/"
    container_path = "/etc/grafana/provisioning/dashboards"
  }
}
```

## GitHub Actions

- `terraform-validate.yml` - Syntax validation on PRs
- `terraform-plan.yml` - Plan generation on PRs  
- `terraform-apply.yml` - Manual deployments
- `terraform-destroy.yml` - Infrastructure cleanup

## Monitoring

**Metrics:**
- System: CPU, memory, disk
- Containers: Resource usage
- Apps: HTTP requests, response times

**Alerts:**
- High CPU/memory usage
- Container failures
- Application errors

## Usage

```bash
terraform init
terraform apply
```

**Access:**
- Grafana: http://localhost:3000 (admin/admin123)
- Prometheus: http://localhost:9090
- Loki: http://localhost:3100
```
