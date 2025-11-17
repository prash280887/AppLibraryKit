# GitHub Secrets Setup Guide

This guide helps configure all required GitHub repository secrets for CI/CD workflows.

## 🔐 Required Secrets

### Azure Authentication
- AZURE_SUBSCRIPTION_ID
- AZURE_TENANT_ID
- AZURE_CLIENT_ID
- AZURE_CLIENT_SECRET

### Azure Resources
- AZURE_RESOURCE_GROUP
- AZURE_STORAGE_ACCOUNT
- AZURE_APPSERVICE_NAME

### Terraform Backend (Optional)
- TF_BACKEND_RG
- TF_BACKEND_SA
- TF_BACKEND_CONTAINER
- TF_BACKEND_KEY

See SECRETS_SETUP.md for detailed instructions.