locals {
  resource_prefix = lower("${var.prefix}-${var.environment}")
  tagsDefault = {
    Owner       = "Enterprise Scale Analytics Scenario"
    Project     = "Enterprise Scale Analytics Scneario"
    Environment = var.environment
    Toolkit     = "Terraform"
  }
}

locals {
  common_module_params = {
    environment     = var.environment
    location        = var.location
    resource_prefix = lower("${var.prefix}-${var.environment}")
    tenantId        = data.azurerm_client_config.default.tenant_id
    subscriptionId  = data.azurerm_client_config.default.subscription_id
    tags            = merge(var.tags, local.tagsDefault)
    resource_groups = {
      network_resource_group            = "rg-${local.resource_prefix}-network"
      automation_resource_group         = "rg-${local.resource_prefix}-automation"
      management_resource_group         = "rg-${local.resource_prefix}-logging-and-management"
      dns_zone_resource_group           = "rg-${local.resource_prefix}-private-dns"
      data_governance_resource_group    = "rg-${local.resource_prefix}-data-governance"
      containers_resource_group         = "rg-${local.resource_prefix}-containers"
      consumption_resource_group        = "rg-${local.resource_prefix}-consumption"
      monitoring_resource_group         = "rg-${local.resource_prefix}-monitoring"
      integration_resource_group        = "rg-${local.resource_prefix}-integration"
      marketplace_resource_group        = "rg-${local.resource_prefix}-marketplace"
      service_layer_resource_group      = "rg-${local.resource_prefix}-service-layer"
      mesh_service_layer_resource_group = "rg-${local.resource_prefix}-mesh-service-layer"
      shared_services_resource_group    = "rg-${local.resource_prefix}-shared-services"
    }
  }
}

locals {
  remote_private_dns_zones = {
    for zone in var.existing_private_dns.dns_zones : zone => {
      name                = zone
      dns_zone_key        = zone
      region              = var.existing_private_dns.zones_region
      zone_id             = "/subscriptions/${var.existing_private_dns.subscription_id}/resourceGroups/${var.existing_private_dns.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${zone}"
      resource_group_name = var.existing_private_dns.resource_group_name
      vnet_key            = var.existing_private_dns.local_vnet_key
    }
  }
}

locals {
  remote_private_dns_vnet_links = {
    for zone in var.existing_private_dns.dns_zones : zone => {
      name     = zone
      zone_id  = "/subscriptions/${var.existing_private_dns.subscription_id}/resourceGroups/${var.existing_private_dns.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${zone}"
      vnet_key = var.existing_private_dns.local_vnet_key
    }
  }
}

