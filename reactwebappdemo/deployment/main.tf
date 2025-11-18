// Terraform config to provision an Azure Static Web App (Single Page Application)
// for the `reactwebappdemo` project. This will create a resource group and
// an Azure Static Site that integrates with the GitHub repository to build
// and deploy the app (Create React App) from the `main` branch.
//
// Notes:
// - You must run `az login` (or authenticate your CI) before `terraform apply`.
// - The provider will need permissions to create the Static Web App and to
//   configure the GitHub Action deployment. If using a service principal, ensure
//   it has appropriate RBAC.

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" 
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

// ------------------------
// Inputs (change as needed)
// ------------------------
variable "location" {
  description = "Azure region to deploy into"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of resource group to create"
  type        = string
  default     = "reactwebappdemo-rg"
}

variable "site_name" {
  description = "Name of the Azure Static Web App"
  type        = string
  default     = "reactwebappdemo-static-site"
}

variable "repository_url" {
  description = "GitHub repository URL for the app (used by Static Web Apps integration)"
  type        = string
  default     = "https://github.com/prash280887/reactwebappdemo"
}

variable "branch" {
  description = "Repository branch to build from"
  type        = string
  default     = "main"
}

variable "app_location" {
  description = "The app location in the repo (where package.json lives)"
  type        = string
  default     = "/"
}

variable "api_location" {
  description = "Location of Azure Functions api in the repo (if any). Leave empty if none."
  type        = string
  default     = ""
}

variable "app_artifact_location" {
  description = "Folder where the build output will be located after building the app (for CRA, 'build')"
  type        = string
  default     = "build"
}

// ------------------------
// Resources
// ------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
// To keep deployment simple and portable we provision an Azure Storage Account
// configured for Static Website hosting. This provides a reliable host for
// a Single Page Application (SPA) such as a Create React App build output.

// Generate a small random suffix so the storage account name meets global uniqueness
resource "random_id" "sa_suffix" {
  byte_length = 4
}

// Storage account name constraints: lowercase, 3-24 characters. We build
// one by concatenating site_name and a short hex suffix.
locals {
  storage_account_name = substr(lower(replace(var.site_name, "[^a-z0-9]", "")), 0, 14) + random_id.sa_suffix.hex
}

resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  //allow_blob_public_access = true

  // Enable static website hosting for SPA. index and error both point to index.html
  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }
}

// ------------------------
// Outputs
// ------------------------
output "static_website_endpoint" {
  description = "Public URL to reach the static website (primary web endpoint)."
  value       = azurerm_storage_account.sa.primary_web_endpoint
}

output "storage_account_name" {
  description = "The name of the storage account created (useful for az cli or portal)."
  value       = azurerm_storage_account.sa.name
}

output "resource_group" {
  description = "Resource group created for the app"
  value       = azurerm_resource_group.rg.name
}

output "note" {
  value = "This Terraform config provisions a Storage Account with Static Website enabled. To publish the React build files to the $web container you can use the GitHub Actions workflow (deploy to Azure Storage) or az cli 'az storage blob upload-batch' pointed at the build/ folder. The repo also includes a GitHub Actions workflow that deploys to gh-pages; choose the mechanism you prefer."
}