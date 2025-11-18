<#
.SYNOPSIS
  Create an Azure service principal and assign Storage Blob Data Contributor role
  for an existing storage account. Prints secrets suitable for adding to GitHub repo secrets.

USAGE
  Open PowerShell and run (after az login):

    .\create_service_principal.ps1 -ResourceGroupName my-rg -StorageAccountName mystorageacct

  The script will create a service principal and assign the role. It will output
  the values you should copy into GitHub secrets: AZURE_CLIENT_ID, AZURE_CLIENT_SECRET,
  AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $ResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string] $StorageAccountName,

    [Parameter(Mandatory=$false)]
    [string] $SPName = "github-actions-sp-$(Get-Random -Maximum 9999)"
)

function ExitOnError($msg) {
    Write-Error $msg
    exit 1
}

try {
    # Ensure Azure CLI is available
    az --version > $null 2>&1
} catch {
    ExitOnError "Azure CLI (az) is required. Install from https://aka.ms/azcli"
}

Write-Host "Creating service principal '$SPName' and assigning 'Storage Blob Data Contributor' to storage account '$StorageAccountName' in resource group '$ResourceGroupName'..."

# Get subscription and tenant info
$subId = az account show --query id -o tsv
if (-not $subId) { ExitOnError "Unable to determine Azure subscription. Run 'az login' first." }

$tenantId = az account show --query tenantId -o tsv

# Create the service principal with role assignment scoped to the storage account
$storageId = az storage account show -n $StorageAccountName -g $ResourceGroupName --query id -o tsv
if (-not $storageId) { ExitOnError "Storage account not found. Ensure the name and resource group are correct." }

# Create app and service principal
$spJson = az ad sp create-for-rbac --name $SPName --role "Storage Blob Data Contributor" --scopes $storageId --query "{appId:appId, password:password, tenant:tenant}" -o json
if (-not $spJson) { ExitOnError "Failed to create service principal." }

$sp = $spJson | ConvertFrom-Json

Write-Host "Service principal created successfully. Copy the following values to GitHub repo secrets:"
Write-Host "AZURE_CLIENT_ID=$($sp.appId)"
Write-Host "AZURE_CLIENT_SECRET=$($sp.password)"
Write-Host "AZURE_TENANT_ID=$($sp.tenant)"
Write-Host "AZURE_SUBSCRIPTION_ID=$subId"
Write-Host "AZURE_STORAGE_ACCOUNT=$StorageAccountName"
Write-Host "AZURE_RESOURCE_GROUP=$ResourceGroupName"

Write-Host "Done."