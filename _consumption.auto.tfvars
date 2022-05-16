synapse_privatelink_hubs = {
  plh1 = {
    name               = "synplh"
    region             = "region1"
    resource_group_key = "consumption"

    private_endpoints = {
      plhpe1 = {
        name               = "syn-plh"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "integration"

        private_service_connection = {
          name                 = "syn-plh"
          is_manual_connection = false
          subresource_names    = ["web"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.azuresynapse.net"]
        }
      }
    }
  }
}
