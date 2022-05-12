
module "esa-dmz" {
  source               = "./resources"
  global_settings      = var.global_settings
  common_module_params = local.common_module_params
  resource_groups      = var.resource_groups
  #keyvaults                = var.keyvaults
  #keyvault_access_policies = var.keyvault_access_policies
  
  networking = {
    vnets                             = var.vnets
    vnet_peerings_v1                  = var.vnet_peerings_v1
    network_security_group_definition = var.network_security_group_definition
  }

  data_factory = {
    data_factory                                 = var.data_factory
    data_factory_integration_runtime_self_hosted = var.data_factory_integration_runtime_self_hosted
  }

  remote_objects = {
    private_dns = local.existing_private_dns
  }

  diagnostics = {
    diagnostic_log_analytics = var.diagnostic_log_analytics
    diagnostics_destinations = var.diagnostics_destinations
    diagnostics_definition   = var.diagnostics_definition
    #diagnostic_storage_accounts = var.diagnostic_storage_accounts
  }
}
