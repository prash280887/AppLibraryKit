# Azure DevOps Service Connection Setup Guide

This guide walks you through setting up an Azure Service Connection in Azure DevOps for pipeline authentication and deployment.

## 📋 Prerequisites

- Azure subscription with Owner or Contributor role
- Azure DevOps organization admin access
- Azure CLI installed (optional but recommended)
- git installed

## 🔐 Step 1: Create Azure Service Principal

Service Principal allows Azure DevOps to authenticate with Azure without storing credentials in code.

### Option A: Using Azure CLI (Recommended)

```powershell
# Login to Azure
az login

# Set subscription
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"

# Create Service Principal
$SP = az ad sp create-for-rbac `
  --name "applibrarykit-pipeline" `
  --role "Contributor" `
  --scopes "/subscriptions/<YOUR_SUBSCRIPTION_ID>"

# Display credentials (save these!)
$SP | ConvertFrom-Json
```

**Output includes:**
- `appId` → Client ID
- `password` → Client Secret  
- `tenant` → Tenant ID

### Option B: Using Azure Portal

1. Navigate to **Azure Portal** → **Azure Active Directory** → **App registrations**
2. Click **New registration**
   - Name: `applibrarykit-pipeline`
   - Supported account types: Single tenant
   - Click **Register**
3. Copy **Application (client) ID** and **Directory (tenant) ID**
4. Go to **Certificates & secrets**
   - Click **New client secret**
   - Description: `Azure DevOps Pipeline`
   - Expires: 24 months (or as per policy)
   - Click **Add**
   - **Copy the secret value immediately** (you won't see it again)
5. Grant permissions:
   - Go to **Subscriptions** → Your subscription
   - **Access control (IAM)** → **Add role assignment**
   - Role: `Contributor`
   - Members: Search for app name `applibrarykit-pipeline`
   - Click **Review + assign**

## 🔑 Step 2: Gather Required Credentials

From Service Principal creation, you need:

```
Subscription ID:    xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Tenant ID:          xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Service Principal ID (Client ID):  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Service Principal Secret (Password): xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**⚠️ Important:** Treat client secret like a password. Never commit to version control.

## 📋 Step 3: Create Service Connection in Azure DevOps

### Method 1: Automated Service Connection (Recommended)

1. In Azure DevOps, go to **Project Settings** → **Service connections**
2. Click **New service connection**
3. Select **Azure Resource Manager**
4. Select **Service principal (automatic)**
5. Azure portal will open:
   - Select your **Subscription**
   - Select **Resource group** (or leave empty for all)
   - **Service connection name:** `AzureServiceConnection`
   - Check **Grant access permission to all pipelines**
   - Click **Save**
6. Return to Azure DevOps - connection is created!

### Method 2: Manual Service Connection

1. In Azure DevOps, go to **Project Settings** → **Service connections**
2. Click **New service connection**
3. Select **Azure Resource Manager**
4. Select **Service principal (manual)**
5. Fill in credentials:
   - **Subscription ID:** xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   - **Subscription Name:** (your subscription name)
   - **Service principal ID:** xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx (Client ID)
   - **Service principal key:** xxxxx...xxxxx (Client Secret)
   - **Tenant ID:** xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   - **Service connection name:** `AzureServiceConnection`
   - Check **Grant access permission to all pipelines**
6. Click **Verify and save**

## ✅ Step 4: Verify Service Connection

### Test Connection

1. Go to **Project Settings** → **Service connections**
2. Find `AzureServiceConnection`
3. Click the three dots (...) → **Edit**
4. Click **Verify connection**
5. Should show ✅ if successful

## 📝 Step 5: Configure Pipeline Variables

In your Azure DevOps Pipeline, set these variables:

### Required Variables

Add in **Pipeline Settings** → **Variables**:

```
AzureServiceConnection     = AzureServiceConnection
EnvironmentName            = prod
ProjectName                = applibrarykit
ResourceGroupName          = applibrarykit-prod-rg
StorageAccountName         = applibrarykit<unique>
AppServiceName             = applibrarykit-prod-api
ReactAppApiBaseUrl         = https://applibrarykit-prod-api.azurewebsites.net
```

### Secret Variables 🔒

Mark these as **secrets** by clicking lock icon:

```
AzureClientSecret          = xxxxx...xxxxx (Service Principal Password)
AzureClientId              = xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
AzureTenantId              = xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

## 🛡️ Step 6: Security Best Practices

### Credential Rotation

1. **Every 12 months:**
   - Go to Azure Portal → App registrations
   - Select `applibrarykit-pipeline`
   - Go to **Certificates & secrets**
   - Delete old secret
   - Create new secret
   - Update service connection in Azure DevOps

## ✅ Checklist

- [ ] Azure Service Principal created
- [ ] Service connection created in Azure DevOps
- [ ] Service connection verified
- [ ] Pipeline variables configured
- [ ] Secret variables marked as secure
- [ ] Test pipeline executed successfully

---

**Next Steps:**
1. Configure pipeline variables as described above
2. Run test pipeline to verify connectivity
3. Deploy infrastructure with `azure-pipelines-deploy.yml`
