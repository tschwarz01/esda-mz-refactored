locals {
  combined_objects_azuread_apps                                 = {}
  combined_objects_azuread_groups                               = {}
  combined_objects_azuread_service_principals                   = {}
  combined_objects_data_factory                                 = module.data_factory
  combined_objects_data_factory_integration_runtime_self_hosted = module.data_factory_integration_runtime_self_hosted
  combined_objects_diagnostic_storage_accounts                  = {}
  combined_objects_keyvaults                                    = module.keyvaults
  combined_objects_log_analytics                                = module.log_analytics
  combined_objects_managed_identities                           = {}
  combined_objects_mssql_managed_instances                      = {}
  combined_objects_mssql_managed_instances_secondary            = {}
  combined_objects_networking                                   = module.networking
  combined_objects_private_dns                                  = merge(module.private_dns, try(var.remote_objects.private_dns))
  combined_objects_purview_accounts                             = module.purview_accounts
  combined_objects_recovery_vaults                              = module.recovery_vaults
  combined_objects_resource_groups                              = local.resource_groups
  combined_objects_storage_accounts                             = module.storage_accounts
  #combined_objects_virtual_machine_scale_sets                   = module.virtual_machine_scale_sets
  #combined_objects_azurerm_firewalls = module.azurerm_firewalls
}
