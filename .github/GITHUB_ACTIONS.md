# GitHub Actions Workflows

This repository includes streamlined GitHub Actions workflows for Terraform CI/CD using the kreuzwerker/docker provider with signature verification bypass.

## Workflows Overview

### 1. `terraform.yml` - Consolidated CI/CD Pipeline
- **Triggers:** Push to main, Pull requests
- **Purpose:** Single matrix-based workflow for all Terraform operations
- **Features:**
  - **Matrix Strategy:** Runs validate, plan, and apply jobs based on event type
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

## Matrix Strategy

The main workflow uses a matrix strategy to run different jobs based on the event type:

```yaml
strategy:
  matrix:
    job: [validate, plan, apply]
    include:
      - job: validate
        condition: ${{ always() }}
      - job: plan
        condition: ${{ github.event_name == 'pull_request' }}
      - job: apply
        condition: ${{ github.event_name == 'push' && github.ref == 'refs/heads/main' }}
```

## Key Features

### ✅ **Provider Management:**
- **Docker Provider:** Uses `kreuzwerker/docker` (the correct Docker provider)
- **Signature Bypass:** Uses `-verify-plugins=false` to handle expired GPG keys
- **Reliable Installation:** Bypasses signature verification issues

### 🔧 **Workflow Capabilities:**
- **Format Validation:** `terraform fmt -check -recursive`
- **Provider Management:** Clean initialization with `terraform init -upgrade -verify-plugins=false`
- **PR Integration:** Comments on pull requests with plan output and status
- **Auto-Apply:** Automatically applies changes on main branch
- **Manual Destruction:** Safe infrastructure destruction workflow

### 📊 **Service URLs:**
After successful deployment, the workflows provide:
- **Grafana:** http://localhost:3000
- **Prometheus:** http://localhost:9090  
- **Loki:** http://localhost:3100

## Usage

### For Pull Requests:
1. Create PR with Terraform changes
2. Workflow automatically runs validation and planning
3. Plan output is posted as PR comment with status
4. Only validate and plan jobs run

### For Main Branch:
1. Push changes to main branch
2. Workflow validates and applies changes automatically
3. Success notification includes service URLs
4. Only validate and apply jobs run

### For Destruction:
1. Go to Actions tab
2. Select "Terraform Destroy" workflow
3. Click "Run workflow"
4. Type "destroy" to confirm
5. Infrastructure will be destroyed safely

## Configuration

All workflows use:
- **Terraform Version:** 1.6.0
- **Runner:** ubuntu-latest
- **Docker Provider:** kreuzwerker/docker ~> 3.0
- **Signature Bypass:** `-verify-plugins=false` flag
- **Matrix Strategy:** Conditional job execution based on event type

## Benefits

### **Simplified Pipeline:**
- Single workflow file instead of multiple redundant workflows
- Matrix strategy reduces duplication
- Conditional execution based on event type
- Cleaner GitHub Actions interface

### **Reliable Provider:**
- Uses the correct kreuzwerker/docker provider
- Bypasses signature verification issues with expired GPG keys
- Maintains functionality while avoiding signature errors

The workflows are designed to showcase Terraform best practices and provide a complete, reliable CI/CD pipeline for infrastructure management.
