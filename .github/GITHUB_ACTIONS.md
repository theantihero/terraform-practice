# GitHub Actions Workflows

This repository includes streamlined GitHub Actions workflows for Terraform CI/CD using the kreuzwerker/docker provider with signature verification bypass.

## Workflows Overview

### 1. `terraform.yml` - Consolidated CI/CD Pipeline
- **Triggers:** Push to main, Pull requests
- **Purpose:** Single workflow with conditional job execution
- **Features:**
  - **Conditional Jobs:** Runs validate, plan, and apply jobs based on event type
  - **Format Validation:** Ensures code follows Terraform standards
  - **Provider Management:** Uses kreuzwerker/docker with signature bypass
  - **PR Integration:** Comments on pull requests with plan output
  - **Auto-Apply:** Automatically applies changes on main branch
  - **Success Notifications:** Service URLs after deployment

### 2. `terraform-destroy.yml` - Infrastructure Destruction
- **Triggers:** Manual workflow dispatch
- **Purpose:** Safe infrastructure destruction
- **Features:**
  - Confirmation requirement
  - Manual trigger only
  - Destruction notifications

## Job Dependencies and Execution Flow

The main workflow uses job dependencies to ensure proper execution order:

```yaml
jobs:
  validate:
    name: 'Terraform Validate'
    runs-on: ubuntu-latest
    
  plan:
    name: 'Terraform Plan'
    runs-on: ubuntu-latest
    needs: validate  # Only runs if validate passes
    
  apply:
    name: 'Terraform Apply'
    runs-on: ubuntu-latest
    needs: [validate, plan]  # Only runs if both validate and plan pass
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

### Execution Flow:
1. **Validate** always runs first
2. **Plan** only runs if validate passes
3. **Apply** only runs if both validate and plan pass (and on main branch)
4. If any job fails, subsequent jobs are skipped

## Key Features

### ✅ **Provider Management:**
- **Docker Provider:** Uses `kreuzwerker/docker` version 3.0.2 (pinned for stability)
- **Terraform Version:** Updated to 1.13.4 with updated GPG keys
- **Docker Configuration:** Configurable Docker host for CI/CD environments
- **Signature Handling:** Multi-strategy fallback for provider installation issues

### 🔧 **Workflow Capabilities:**
- **Format Validation:** `terraform fmt -check -recursive`
- **Provider Management:** Clean initialization with multi-strategy fallback
- **Job Dependencies:** Validate must pass before plan/apply execution
- **PR Integration:** Comments on pull requests with plan output and status
- **Auto-Apply:** Automatically applies changes on main branch (after validation)
- **Manual Destruction:** Safe infrastructure destruction workflow with validation

### 📊 **Service URLs:**
After successful deployment, the workflows provide:
- **Grafana:** http://localhost:3000
- **Prometheus:** http://localhost:9090  
- **Loki:** http://localhost:3100

## Usage

### For Pull Requests:
1. Create PR with Terraform changes
2. Workflow automatically runs validation, planning, and posts plan as PR comment
3. Plan output is posted as PR comment with status
4. Only validate and plan jobs run

### For Main Branch:
1. Push changes to main branch
2. Workflow validates, plans, and applies changes automatically
3. Success notification includes service URLs
4. All jobs run: validate, plan, and apply

### For Destruction:
1. Go to Actions tab
2. Select "Terraform Destroy" workflow
3. Click "Run workflow"
4. Type "destroy" to confirm
5. Infrastructure will be destroyed safely

## Docker Configuration

The workflows automatically configure Docker for CI/CD environments:

- **Local Development:** Uses `npipe:////./pipe/docker_engine` (Windows) or `unix:///var/run/docker.sock` (Linux)
- **GitHub Actions:** Uses `unix:///var/run/docker.sock` via `TF_VAR_docker_host` environment variable
- **Docker Buildx:** Set up automatically for container operations

## Configuration

All workflows use:
- **Terraform Version:** 1.13.4
- **Runner:** ubuntu-latest
- **Docker Provider:** kreuzwerker/docker 3.0.2 (pinned version)
- **Docker Host:** Configurable via `TF_VAR_docker_host` environment variable
- **Signature Handling:** Multi-strategy fallback approach
- **Conditional Execution:** Job execution based on event type

## Benefits

### **Simplified Pipeline:**
- Single workflow file instead of multiple redundant workflows
- Conditional job execution reduces duplication
- Event-based job triggering
- Cleaner GitHub Actions interface

### **Reliable Provider:**
- Uses the correct kreuzwerker/docker provider
- Bypasses signature verification issues with expired GPG keys
- Maintains functionality while avoiding signature errors

The workflows are designed to showcase Terraform best practices and provide a complete, reliable CI/CD pipeline for infrastructure management.
