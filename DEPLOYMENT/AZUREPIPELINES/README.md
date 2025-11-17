# Azure DevOps Pipeline Setup Guide

This directory contains Azure DevOps pipeline YAML scripts for building, testing, and deploying the AppLibraryKit full-stack application to Azure.

## 📋 Contents

- **azure-pipelines-ci.yml** - Continuous Integration pipeline (Build, Test, Code Quality)
- **azure-pipelines-deploy.yml** - Deployment pipeline (Infrastructure & App Deployment)
- **terraform/** - Infrastructure as Code templates
  - `main.tf` - Azure resource definitions
  - `outputs.tf` - Terraform output configurations
  - `terraform.tfvars.example` - Example variable values
- **SERVICE_CONNECTION_SETUP.md** - Service connection configuration guide
- **QUICKSTART.md** - 5-minute setup guide

## 🚀 Quick Start

See [QUICKSTART.md](QUICKSTART.md) for 5-minute setup instructions.

## 📚 Full Documentation

For detailed setup and troubleshooting:
1. [SERVICE_CONNECTION_SETUP.md](SERVICE_CONNECTION_SETUP.md) - Service connection configuration
2. [QUICKSTART.md](QUICKSTART.md) - 5-minute quick start
3. [README.md](README.md) - Complete setup guide
