vmss_extensions_custom_script_adf_integration_runtime = {

  vmssshir1 = {
    resource_group_key        = "integration"
    identity_type             = "SystemAssigned" # optional to use managed_identity for download from location specified in fileuri, UserAssigned or SystemAssigned.
    automatic_upgrade_enabled = false

    integration_runtime_key = "dfirsh1"
    vmss_key                = "vmssshir"
    basecommandtoexecute    = "powershell.exe -ExecutionPolicy Unrestricted -File installSHIRGateway.ps1 -gatewayKey"
    script_location         = "https://raw.githubusercontent.com/Azure/data-landing-zone/main/code/installSHIRGateway.ps1"
    #authorization_key       = try(local.combined_objects_data_factory_integration_runtime_self_hosted[each.integration_runtime.key].primary_authorization_key, null)
  }

}
