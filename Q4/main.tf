variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "xxxx-xxxxx-xxxx"
}

variable "location" {
  description = "Azure resources location"
  type        = string
  default     = "WestEurope"
}

variable "project" {
  description = "The name of the project"
  type        = string
  default     = "zurichq4"
}

variable "environment" {
  description = "The environment name"
  type        = string
  default     = "poc"
}

variable "blob_name" {
  description = "The name of the Blob"
  type        = string
  default     = "demoblob"
}

variable "container_name" {
  description = "The name of the Storage Container"
  type        = string
  default     = "democont"
}

variable "policy_name" {
  description = "The name of the storage management policy"
  type        = string
  default     = "deleteversionafter60days_policy"
}

resource "azurerm_resource_group" "rg_storage" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location

  tags = {
    owner       = "Wael Amer"
    environment = var.environment
    project     = var.project
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "st${var.project}${var.environment}"
  resource_group_name      = azurerm_resource_group.rg_storage.name
  location                 = azurerm_resource_group.rg_storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }
  }

  https_traffic_only_enabled = true

  min_tls_version = "TLS1_2"

  tags = {
    owner       = "Wael Amer"
    environment = var.environment
    project     = var.project
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

# resource "azurerm_storage_container_immutability_policy" "immutability_policy" {
#   storage_container_resource_manager_id = azurerm_storage_container.storage_container.id
#   immutability_period_in_days           = 60
# }

resource "azurerm_storage_blob" "storage_blob" {
  name                   = var.blob_name
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
#   source                 = "path/to/${var.blob_name}"
}

data "azurerm_storage_account_sas" "sas_token" {
  connection_string = azurerm_storage_account.storage_account.primary_connection_string

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = true
    add     = false
    create  = false
    update  = false
    process = false
    filter  = false
    tag     = false
  }

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    file  = false
    table = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "1h")
}

output "sas_url" {
  description = "SAS URL for the blob with read-only access"
  value       = replace("${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.storage_container.name}/${azurerm_storage_blob.storage_blob.name}${data.azurerm_storage_account_sas.sas_token.sas}", "\u0026", "&") 
  sensitive   = true
}


resource "azurerm_storage_management_policy" "lifecycle_policy" {
  storage_account_id = azurerm_storage_account.storage_account.id

  rule {
    name    = var.policy_name
    enabled = true

    filters {
      prefix_match = [var.container_name]
      blob_types   = ["blockBlob", "appendBlob"]
    }

    actions {
      version {
        change_tier_to_archive_after_days_since_creation = null
        change_tier_to_cool_after_days_since_creation    = null
        delete_after_days_since_creation                 = 60
      }
    }
  }
}
