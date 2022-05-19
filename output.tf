/*
output "existing_dns" {
  value = local.existing_private_dns
}




output "vaultcore" {
  value = module.esa-dmz.combined_dns["privatelink.vaultcore.azure.net"].id
}


output "adf" {
  value = module.esa-dmz.data_factory
}

output "vnetlinks" {
  value = module.esa-dmz.private_dns_vnet_links
}

output "pv" {
  value = module.esa-dmz.purview_accounts
}


*/

output "combinedobjectsprivatedns" {
  value = module.esa-dmz.copdns
}

output "acrdns" {
  value = module.esa-dmz.copdns["privatelink.azurecr.io"]
}

output "acr" {
  value = module.esa-dmz.azure_container_registries

}
