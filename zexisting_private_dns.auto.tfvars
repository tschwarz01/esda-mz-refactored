existing_private_dns = {
  subscription_id     = "c00669a2-37e9-4e0d-8b57-4e8dd0fcdd4a"
  resource_group_name = "rg-scus-pe-lab-network"
  dns_zones = [
    "privatelink.blob.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com" 
  ]
}
