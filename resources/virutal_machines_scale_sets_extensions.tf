module "vmss_extension_custom_scriptextension" {
  source = ".//compute/virtual_machine_scale_set_extensions"

  for_each = {
    for key, value in try(local.compute.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.custom_script, null) != null
  }

  client_config                     = local.client_config
  virtual_machine_scale_set_id      = module.virtual_machine_scale_sets[each.key].id
  extension                         = each.value.virtual_machine_scale_set_extensions.custom_script
  extension_name                    = "custom_script"
  managed_identities                = local.combined_objects_managed_identities
  storage_accounts                  = local.combined_objects_storage_accounts
  virtual_machine_scale_set_os_type = module.virtual_machine_scale_sets[each.key].os_type
}

module "vmss_extension_custom_script_adf_integration_runtime" {
  source = ".//compute/virtual_machine_scale_set_extensions"

  for_each = {
    for key, value in try(local.compute.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.custom_script, null) != null && try(value.virtual_machine_scale_set_extensions.custom_script.adf_integration_runtime, null) != null
  }

  client_config                     = local.client_config
  virtual_machine_scale_set_id      = module.virtual_machine_scale_sets[each.key].id
  extension                         = each.value.virtual_machine_scale_set_extensions.adf_integration_runtime
  extension_name                    = "custom_script"
  managed_identities                = local.combined_objects_managed_identities
  storage_accounts                  = local.combined_objects_storage_accounts
  integration_runtimes              = local.combined_objects_data_factory_integration_runtime_self_hosted
  keyvaults                         = local.combined_objects_keyvaults
  virtual_machine_scale_set_os_type = module.virtual_machine_scale_sets[each.key].os_type
  integration_runtime = {
    commandtoexecute = "${value.virtual_machine_scale_set_extensions.custom_script.adf_integration_runtime.basecommandtoexecute} ${try(local.combined_objects_data_factory_integration_runtime_self_hosted[value.virtual_machine_scale_set_extensions.custom_script.adf_integration_runtime.integration_runtime_key].primary_authorization_key, null)}"
    fileuris         = ["${value.virtual_machine_scale_set_extensions.custom_script.adf_integration_runtime.script_location}"]
  }

}

/*
virtual_machine_scale_set_extension = {
  adf_integration_runtime = {
    integration_runtime_key = "dfirsh1"
    basecommandtoexecute    = "powershell.exe -ExecutionPolicy Unrestricted -File installSHIRGateway.ps1 -gatewayKey"
    script_location         = "https://raw.githubusercontent.com/Azure/data-landing-zone/main/code/installSHIRGateway.ps1"
    authorization_key       = try(local.combined_objects_data_factory_integration_runtime_self_hosted[each.integration_runtime.key].primary_authorization_key, null)
  }
}
*/

module "vmss_extension_microsoft_azure_domainjoin" {
  source = ".//compute/virtual_machine_scale_set_extensions"

  for_each = {
    for key, value in try(local.compute.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.microsoft_azure_domainjoin, null) != null
  }

  client_config                = local.client_config
  virtual_machine_scale_set_id = module.virtual_machine_scale_sets[each.key].id
  extension                    = each.value.virtual_machine_scale_set_extensions.microsoft_azure_domainjoin
  extension_name               = "microsoft_azure_domainJoin"
  keyvaults                    = local.combined_objects_keyvaults
}


module "vmss_extension_microsoft_monitoring_agent" {
  source = ".//compute/virtual_machine_scale_set_extensions"
  for_each = {
    for key, value in try(local.compute.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.microsoft_monitoring_agent, null) != null
  }

  client_config                     = local.client_config
  virtual_machine_scale_set_id      = module.virtual_machine_scale_sets[each.key].id
  extension                         = each.value.virtual_machine_scale_set_extensions.microsoft_monitoring_agent
  extension_name                    = "microsoft_monitoring_agent"
  virtual_machine_scale_set_os_type = module.virtual_machine_scale_sets[each.key].os_type
  log_analytics_workspaces          = local.combined_objects_log_analytics
}

module "vmss_extension_dependency_agent" {
  source = ".//compute/virtual_machine_scale_set_extensions"
  for_each = {
    for key, value in try(local.compute.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.dependency_agent, null) != null
  }

  client_config                     = local.client_config
  virtual_machine_scale_set_id      = module.virtual_machine_scale_sets[each.key].id
  extension                         = each.value.virtual_machine_scale_set_extensions.dependency_agent
  extension_name                    = "dependency_agent"
  virtual_machine_scale_set_os_type = module.virtual_machine_scale_sets[each.key].os_type
}
