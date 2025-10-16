# GitHub Actions Workflows

This repository includes several GitHub Actions workflows for Terraform CI/CD with robust provider signature handling.

## 🚨 **Provider Signature Issue Resolution**

The workflows include comprehensive fallback strategies to handle the `kreuzwerker/docker` provider signature verification error that occurs due to expired OpenPGP keys.

## Workflows Overview

### 1. `terraform-plan.yml` - Pull Request Planning
- **Triggers:** Pull requests to main branch
- **Purpose:** Validates and plans Terraform changes
- **Features:**
  - Format checking
  - Terraform validation
  - Plan generation
  - PR comments with plan output
  - **Provider signature fallback handling**

### 2. `terraform-ci.yml` - Complete CI/CD Pipeline
- **Triggers:** Push to main, Pull requests
- **Purpose:** Full CI/CD pipeline with separate jobs
- **Features:**
  - Validation job (format, init, validate)
  - Plan job (for PRs)
  - Apply job (for main branch pushes)
  - Error handling and status reporting
  - **Multi-strategy provider initialization**

### 3. `terraform-pipeline.yml` - Advanced Pipeline
- **Triggers:** Push to main, Pull requests
- **Purpose:** Comprehensive pipeline with dependencies
- **Features:**
  - Sequential job execution
  - PR plan comments
  - Auto-apply on main branch
  - Success notifications with service URLs
  - **Robust provider management**

### 4. `terraform-destroy.yml` - Infrastructure Destruction
- **Triggers:** Manual workflow dispatch
- **Purpose:** Safe infrastructure destruction
- **Features:**
  - Confirmation requirement
  - Manual trigger only
  - Destruction notifications
  - **Provider signature handling**

### 5. `terraform-provider-fix.yml` - Alternative Approach
- **Triggers:** Push to main, Pull requests
- **Purpose:** Dedicated workflow with provider signature bypass
- **Features:**
  - CLI configuration override
  - Multiple initialization methods
  - Comprehensive error handling

## 🛠️ **Provider Signature Fallback Strategy**

Each workflow uses a multi-step approach to handle provider signature issues:

```bash
# Method 1: Normal init with upgrade
terraform init -upgrade || {
  echo "Normal init failed, trying with provider cache bypass..."
  
  # Method 2: Clear cache and retry
  rm -rf .terraform/providers
  terraform init -upgrade || {
    echo "Provider signature issue detected, using alternative approach..."
    
    # Method 3: Backend bypass
    terraform init -upgrade -backend=false || {
      # Method 4: Reconfigure
      terraform init -reconfigure || terraform init
    }
  }
}
```

## Key Features

### ✅ **Fixed Issues:**
- **Provider Signature:** Multi-strategy fallback for Docker provider signature issues
- **Step References:** Fixed step ID references in PR comments
- **Error Handling:** Added proper error handling and status reporting
- **Format Checking:** Includes `terraform fmt -check -recursive` validation
- **Cache Management:** Automatic provider cache clearing when needed

### 🔧 **Workflow Capabilities:**
- **Format Validation:** Ensures code follows Terraform standards
- **Provider Management:** Handles Docker provider initialization with fallbacks
- **PR Integration:** Comments on pull requests with plan output and status
- **Auto-Apply:** Automatically applies changes on main branch
- **Manual Destruction:** Safe infrastructure destruction workflow
- **Robust Error Handling:** Multiple fallback methods for provider issues

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
4. Provider signature issues are handled automatically

### For Main Branch:
1. Push changes to main branch
2. Workflow validates and applies changes automatically
3. Success notification includes service URLs
4. Provider initialization uses fallback strategies

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
- **Provider Signature Handling:** Multi-strategy fallback approach

## 🔍 **Troubleshooting**

If workflows still fail:

1. **Check the logs** for specific error messages
2. **Try the alternative workflow** (`terraform-provider-fix.yml`)
3. **Verify provider versions** in `main.tf`
4. **Clear GitHub Actions cache** if needed

The workflows are designed to showcase Terraform best practices and provide a complete, robust CI/CD pipeline for infrastructure management with comprehensive provider signature issue handling.
