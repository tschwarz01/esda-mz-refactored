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
*/

output "priv_dns" {
  value = module.esa-dmz.private_dns
}
