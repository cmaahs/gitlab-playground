resource "azurerm_storage_account" "main" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.env.name
  location                 = azurerm_resource_group.env.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # CKV_AZURE_3: Ensure that 'Secure transfer required' is set to 'Enabled'
  enable_https_traffic_only = true

  # CKV_AZURE_44: Ensure Storage Account is using the latest version
  # of TLS encryption
  min_tls_version = "TLS1_2"

  # CKV_AZURE_33: Ensure Storage logging is enabled for Queue service for read,
  # write and delete requests (enabled only if storage_logging_enabled=true)
  dynamic "queue_properties" {
    for_each = var.storage_logging_enabled ? [true] : []

    content {
      logging {
        delete                = true
        read                  = true
        write                 = true
        version               = "1.0"
        retention_policy_days = var.storage_logging_retention
      }
      hour_metrics {
        enabled               = true
        include_apis          = true
        version               = "1.0"
        retention_policy_days = var.storage_logging_retention
      }
      minute_metrics {
        enabled               = true
        include_apis          = true
        version               = "1.0"
        retention_policy_days = var.storage_logging_retention
      }
    }
  }

  tags = local.common_tags

  depends_on = [azurerm_resource_group.env]
}

resource "azurerm_storage_management_policy" "main" {
  storage_account_id = azurerm_storage_account.main.id

  rule {
    name    = "BackupCleanup"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = var.backup_retention
      }
    }
  }
}
