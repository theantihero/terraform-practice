# GitHub Actions Workflows

This repository includes several GitHub Actions workflows for Terraform CI/CD:

## Workflows Overview

### 1. `terraform-plan.yml` - Pull Request Planning
- **Triggers:** Pull requests to main branch
- **Purpose:** Validates and plans Terraform changes
- **Features:**
  - Format checking
  - Terraform validation
  - Plan generation
  - PR comments with plan output

### 2. `terraform-ci.yml` - Complete CI/CD Pipeline
- **Triggers:** Push to main, Pull requests
- **Purpose:** Full CI/CD pipeline with separate jobs
- **Features:**
  - Validation job (format, init, validate)
  - Plan job (for PRs)
  - Apply job (for main branch pushes)
  - Error handling and status reporting

### 3. `terraform-pipeline.yml` - Advanced Pipeline
- **Triggers:** Push to main, Pull requests
- **Purpose:** Comprehensive pipeline with dependencies
- **Features:**
  - Sequential job execution
  - PR plan comments
  - Auto-apply on main branch
  - Success notifications with service URLs

### 4. `terraform-destroy.yml` - Infrastructure Destruction
- **Triggers:** Manual workflow dispatch
- **Purpose:** Safe infrastructure destruction
- **Features:**
  - Confirmation requirement
  - Manual trigger only
  - Destruction notifications

## Key Features

### ✅ **Fixed Issues:**
- **Provider Signature:** Uses `terraform init -upgrade` to handle Docker provider signature issues
- **Step References:** Fixed step ID references in PR comments
- **Error Handling:** Added proper error handling and status reporting
- **Format Checking:** Includes `terraform fmt -check -recursive` validation

### 🔧 **Workflow Capabilities:**
- **Format Validation:** Ensures code follows Terraform standards
- **Provider Management:** Handles Docker provider initialization
- **PR Integration:** Comments on pull requests with plan output
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
3. Plan output is posted as PR comment

### For Main Branch:
1. Push changes to main branch
2. Workflow validates and applies changes automatically
3. Success notification includes service URLs

### For Destruction:
1. Go to Actions tab
2. Select "Terraform Destroy" workflow
3. Click "Run workflow"
4. Type "destroy" to confirm
5. Infrastructure will be destroyed

## Configuration

All workflows use:
- **Terraform Version:** 1.6.0
- **Runner:** ubuntu-latest
- **Docker Provider:** kreuzwerker/docker ~> 3.0

The workflows are designed to showcase Terraform best practices and provide a complete CI/CD pipeline for infrastructure management.
