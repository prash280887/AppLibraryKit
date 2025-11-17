# Quick Start Guide

## 5-Minute Setup

### 1. Create Azure Service Principal
```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac \
  --name "github-actions-applibrarykit" \
  --role "Contributor" \
  --scopes "/subscriptions/$SUBSCRIPTION_ID" \
  --output json
```

### 2. Add GitHub Secrets
```bash
gh secret set AZURE_SUBSCRIPTION_ID --body "<value>"
gh secret set AZURE_TENANT_ID --body "<value>"
gh secret set AZURE_CLIENT_ID --body "<value>"
gh secret set AZURE_CLIENT_SECRET --body "<value>"
gh secret set AZURE_RESOURCE_GROUP --body "applibrarykit-prod-rg"
gh secret set AZURE_STORAGE_ACCOUNT --body "applibrarykit<suffix>"
gh secret set AZURE_APPSERVICE_NAME --body "applibrarykit-prod-api"
```

### 3. Deploy
```bash
git push origin main
```

Workflows will automatically trigger! See README.md for full documentation.
