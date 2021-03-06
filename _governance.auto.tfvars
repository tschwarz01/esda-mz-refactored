purview_accounts = {
  pva1 = {
    name                        = "pva1"
    region                      = "region1"
    public_network_enabled      = false
    managed_resource_group_name = "rg1-purview"
    resource_group = {
      key = "governance"
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "purview_account"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    private_endpoints = {
      account = {
        name               = "account"
        resource_group_key = "governance"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "account"
          is_manual_connection = false
          subresource_names    = ["account"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.purview.azure.com"]
        }
      }
      portal = {
        name               = "portal"
        resource_group_key = "governance"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "portal"
          is_manual_connection = false
          subresource_names    = ["portal"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.purviewstudio.azure.com"]
        }
      }
    }
    # Requires azurerm >= 2.92.0
    managed_resource_private_endpoints = {
      blob = {
        name               = "blob"
        resource_group_key = "governance"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "blob"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.blob.core.windows.net"]
        }
      }
      queue = {
        name               = "queue"
        resource_group_key = "governance"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "queue"
          is_manual_connection = false
          subresource_names    = ["queue"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.queue.core.windows.net"]
        }
      }
      eventhub = {
        name               = "eventhub"
        resource_group_key = "governance"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "eventhub"
          is_manual_connection = false
          subresource_names    = ["namespace"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.servicebus.windows.net"]
        }
      }
    }
  }
}

shared_image_galleries = {
  gallery1 = {
    name               = "img-gallery"
    resource_group_key = "governance"
    description        = ""
  }
}

azure_container_registries = {
  acr1 = {
    name                          = "acr005"
    resource_group_key            = "governance"
    sku                           = "Premium"
    quarantine_policy_enabled     = true
    public_network_access_enabled = false

    retention_policy = {
      days    = 7
      enabled = true
    }

    diagnostic_profiles = {
      operations = {
        name             = "acr_logs"
        definition_key   = "azure_container_registry"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    private_endpoints = {
      acr = {
        name               = "acr001"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "governance"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }

        private_service_connection = {
          name                 = "acr0031"
          is_manual_connection = false
          subresource_names    = ["registry"]
        }
        private_dns = {
          zone_group_name = "privatelink.azurecr.io"
          keys            = ["privatelink.azurecr.io"]
        }
      }
    }
  }
}

