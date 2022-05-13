
module "esa-dmz" {
  source                   = "./resources"
  global_settings          = var.global_settings
  common_module_params     = local.common_module_params
  resource_groups          = var.resource_groups
  keyvaults                = var.keyvaults
  keyvault_access_policies = var.keyvault_access_policies
  managed_identities       = var.managed_identities

  networking = {
    vnets                             = var.vnets
    vnet_peerings_v1                  = var.vnet_peerings_v1
    network_security_group_definition = var.network_security_group_definition
    application_security_groups       = var.application_security_groups
    public_ip_addresses               = var.public_ip_addresses
    load_balancers                    = var.load_balancers
  }

  compute = {
    virtual_machine_scale_sets                            = var.virtual_machine_scale_sets
    vmss_extensions_custom_script_adf_integration_runtime = var.vmss_extensions_custom_script_adf_integration_runtime
  }

  data_factory = {
    data_factory                                 = var.data_factory
    data_factory_integration_runtime_self_hosted = var.data_factory_integration_runtime_self_hosted
  }

  purview = {
    purview_accounts = var.purview_accounts
  }

  remote_objects = {
    private_dns = local.existing_private_dns
  }

  diagnostics = {
    diagnostic_log_analytics    = var.diagnostic_log_analytics
    diagnostics_destinations    = var.diagnostics_destinations
    diagnostics_definition      = var.diagnostics_definition
    diagnostic_storage_accounts = var.diagnostic_storage_accounts
  }
}
