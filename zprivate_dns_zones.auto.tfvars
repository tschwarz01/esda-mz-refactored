# You will likely want to comment out one of the two sections below
# One allows you to specify that existing private dns zones, likely deployed in a separate subscription, should be used
# The second allows you to define the private dns zones which should be created in the subscription to which you are deploying this template

existing_private_dns = {
  subscription_id     = "c00669a2-37e9-4e0d-8b57-4e8dd0fcdd4a"
  resource_group_name = "rg-scus-pe-lab-network"
  zones_region        = "region1"
  local_vnet_key      = "vnet_region1"
  dns_zones = [
    "privatelink.blob.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com",
    "privatelink.servicebus.windows.net",
    "privatelink.azurecr.io",
    "privatelink.azuresynapse.net",
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net"
  ]
}


// TODO - add section #2
