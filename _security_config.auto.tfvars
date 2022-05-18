managed_identities = {
  vmssadf = {
    name               = "vmssadf"
    resource_group_key = "integration"
  }
}

# Application security groups
application_security_groups = {
  app_sg1 = {
    resource_group_key = "integration"
    name               = "app_sg1"

  }
}

dynamic_keyvault_secrets = {
  kv1 = {
    shirKey = {
      # this secret is retrieved automatically from the module run output
      secret_name   = "shir-auth-key"
      output_key    = "data_factory_integration_runtime_self_hosted"
      resource_key  = "dfirsh1"
      attribute_key = "primary_authorization_key"
    }
  }
}


keyvaults = {
  kv1 = {
    name               = "dmzintegration12"
    resource_group_key = "integration"
    sku_name           = "standard"
    #enable_rbac_authorization = true
    soft_delete_enabled      = true
    purge_protection_enabled = true
    creation_policies = {
      object_id = {
        object_id               = "6405df78-1204-44e2-b0d2-6666c8d83f71"
        certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "GetIssuers", "SetIssuers", "ListIssuers", "DeleteIssuers", "ManageIssuers", "Restore", "ManageContacts"]
        secret_permissions      = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_key_vault"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    private_endpoints = {
      vault = {
        name               = "dmzint"
        resource_group_key = "integration"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "dmzint"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.net"]
        }
      }
    }
  }
  kv2 = {
    name                      = "dmzgovernance12"
    resource_group_key        = "governance"
    sku_name                  = "standard"
    enable_rbac_authorization = true
    soft_delete_enabled       = true
    purge_protection_enabled  = true
    network = {
      default_action = "Deny"
      bypass         = "AzureServices"
      ip_rules       = []
      subnets = {
        servicesSubnetName = {
          vnet_key   = "vnet_region1"
          subnet_key = "services"
        }
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_key_vault"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    private_endpoints = {
      vault = {
        name               = "dmzgovernance"
        resource_group_key = "governance"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "dmzgovernance"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.net"]
        }
      }
    }
  }
}
