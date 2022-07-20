########### VARIABLES #################

# Get PublicIP locally
data "external" "public_ip" {
  program = [
    "bash", "-c", <<EOF
    curl -s ifconfig.me/all.json | jq '{ip_addr: .ip_addr}'
    EOF
  ]
}


locals {
  formatted_timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
  machine_public_ip   = data.external.public_ip.result.ip_addr
}


############### RESOURCES #####################

# CREATE new storage account
resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# CREATE a new azure key vault
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "myakv" {
  name                        = var.akv_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    # permission too wide, make sure to adjust them accordingly
    storage_permissions = [
      "Get",
      "GetSAS",
      "List",
      "ListSAS",
      "Delete",
      "Backup",
      "DeleteSAS",
      "Purge",
      "Recover",
      "RegenerateKey",
      "Restore",
      "Set",
      "SetSAS",
      "Update"
    ]
  }
}

resource "azurerm_key_vault_managed_storage_account" "mystorageaccount" {
  name                         = var.storage_account_name
  key_vault_id                 = azurerm_key_vault.myakv.id
  storage_account_id           = azurerm_storage_account.example.id
  storage_account_key          = "key1"
  regenerate_key_automatically = false
  regeneration_period          = "P1D"
}

resource "azurerm_key_vault_managed_storage_account" "mystorageaccount_2" {
  name                         = var.storage_account_name
  key_vault_id                 = azurerm_key_vault.myakv.id
  storage_account_id           = azurerm_storage_account.example.id
  storage_account_key          = "key2"
  regenerate_key_automatically = false
  regeneration_period          = "P1D"
}

# CREATE a storage account
# resource "azurerm_storage_account" "mystorageaccount" {
#   name                     = var.storage_account_name
#   location                 = var.location
#   resource_group_name      = var.resource_group_name
#   account_tier             = "Standard"
#   account_kind             = "StorageV2"
#   account_replication_type = "LRS"

#   # add link to azure key vault
#   customer_managed_key {
#     key_vault_key_id          = azurerm_key_vault.myakv.id
#     user_assigned_identity_id = data.azurerm_client_config.current.object_id
#   }

#   identity {
#     type = "UserAssigned"
#   }

#   network_rules {
#     default_action = "Deny"
#     ip_rules = [
#       local.machine_public_ip
#     ]
#   }
# }

# create a container in our storage account
# resource "azurerm_storage_container" "mycontainer" {
#   name                  = "test-container-1"
#   storage_account_name  = azurerm_storage_account.mystorageaccount.name
#   container_access_type = "private"
# }
