azure_container_registries = {
  acr1 = {
    name               = "acr001"
    resource_group_key = "consumption"
    sku                = "Premium"
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
        resource_group_key = "consumption"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "acr001"
          is_manual_connection = false
          subresource_names    = ["registry"]
        }
      }
    }
  }
}
