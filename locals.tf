locals {
  common_module_params = {
    environment     = var.environment
    location        = var.location
    resource_prefix = lower("${var.prefix}-${var.environment}")
    tenantId        = data.azurerm_client_config.default.tenant_id
    subscriptionId  = data.azurerm_client_config.default.subscription_id
    #tags            = merge(var.tags, local.tagsDefault)
  }
}

locals {
  remote_private_dns_zones = {
    for zone in var.existing_private_dns.dns_zones : zone => {
      name                = zone
      dns_zone_key        = zone
      region              = var.existing_private_dns.zones_region
      zone_id             = "/subscriptions/${var.existing_private_dns.subscription_id}/resourceGroups/${var.existing_private_dns.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${zone}"
      id                  = "/subscriptions/${var.existing_private_dns.subscription_id}/resourceGroups/${var.existing_private_dns.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${zone}"
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
      id       = "/subscriptions/${var.existing_private_dns.subscription_id}/resourceGroups/${var.existing_private_dns.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${zone}"
      vnet_key = var.existing_private_dns.local_vnet_key
    }
  }
}

###

