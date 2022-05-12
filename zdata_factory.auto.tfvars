data_factory = {
  df1 = {
    name = "adf-int"
    resource_group = {
      key = "integration"
      #lz_key = ""
      #name = ""
    }
    managed_virtual_network_enabled = "true"
    private_endpoints = {
      # Require enforce_private_link_endpoint_network_policies set to true on the subnet
      df1-factory = {
        name               = "adf-int-acct"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "integration"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "adf-int-acct"
          is_manual_connection = false
          subresource_names    = ["dataFactory"]
        }
        private_dns = {
          zone_group_name = "privatelink.datafactory.azure.net"
          # lz_key          = ""   # If the DNS keys are deployed in a remote landingzone
          keys = ["privatelink.datafactory.azure.net"]
        }
      }
      df1-portal = {
        name               = "adf-int-portal"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "integration"
        private_service_connection = {
          name                 = "adf-int-portal"
          is_manual_connection = false
          subresource_names    = ["portal"]
        }
        private_dns = {
          zone_group_name = "privatelink.adf.azure.com"
          # lz_key          = ""   # If the DNS keys are deployed in a remote landingzone
          keys = ["privatelink.adf.azure.com"]
        }
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_data_factory"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}

data_factory_integration_runtime_self_hosted = {
  dfirsh1 = {
    name = "adfsharedshir"
    resource_group = {
      key = "integration"
    }
    data_factory = {
      key = "df1"
    }
  }
}
