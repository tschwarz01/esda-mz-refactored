
virtual_machine_scale_sets = {
  vmssshir = {
    resource_group_key                   = "integration"
    provision_vm_agent                   = true
    boot_diagnostics_storage_account_key = "bootdiag1"
    os_type                              = "windows"
    keyvault_key                         = "kv1"

    vmss_settings = {
      windows = {
        name                            = "win"
        computer_name_prefix            = "win"
        sku                             = "Standard_F2"
        instances                       = 2
        admin_username                  = "adminuser"
        disable_password_authentication = false
        priority                        = "Spot"
        eviction_policy                 = "Deallocate"
        upgrade_mode                    = "Automatic" # Automatic / Rolling / Manual
        #custom_data                     = null

        rolling_upgrade_policy = {
          max_batch_instance_percent              = 60
          max_unhealthy_instance_percent          = 60
          max_unhealthy_upgraded_instance_percent = 60
          pause_time_between_batches              = "PT01M"
        }
        automatic_os_upgrade_policy = {
          disable_automatic_rollback  = false
          enable_automatic_os_upgrade = false
        }

        os_disk = {
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
          disk_size_gb         = 128
        }

        identity = {
          type                  = "UserAssigned"
          managed_identity_keys = ["vmssadf"]
        }

        source_image_reference = {
          publisher = "MicrosoftWindowsServer"
          offer     = "WindowsServer"
          sku       = "2019-Datacenter"
          version   = "latest"
        }

        automatic_instance_repair = {
          enabled      = true
          grace_period = "PT30M" # Use ISO8601 expressions.
        }

        health_probe = {
          loadbalancer_key = "lb-vmss"
          probe_key        = "probe1"
        }
      }
    }

    network_interfaces = {
      nic0 = {
        name       = "0"
        primary    = true
        vnet_key   = "vnet_region1"
        subnet_key = "services"
        #subnet_id  = 

        enable_accelerated_networking = false
        enable_ip_forwarding          = false
        internal_dns_name_label       = "nic0"
        load_balancers = {
          lb1 = {
            lb_key = "lb-vmss"
            # lz_key = ""
          }
        }
        application_security_groups = {
          asg1 = {
            asg_key = "app_sg1"
            # lz_key = ""
          }
        }
      }
    }
    ultra_ssd_enabled = false
    /**/
  }
}

vmss_extensions_custom_script_adf_integration_runtime = {

  vmssshir1 = {
    resource_group_key        = "integration"
    identity_type             = "SystemAssigned" # optional to use managed_identity for download from location specified in fileuri, UserAssigned or SystemAssigned.
    automatic_upgrade_enabled = false

    integration_runtime_key = "dfirsh1"
    vmss_key                = "vmssshir"
    commandtoexecute        = "powershell.exe -ExecutionPolicy Unrestricted -File installSHIRGateway.ps1 -gatewayKey"
    script_location         = "https://raw.githubusercontent.com/Azure/data-landing-zone/main/code/installSHIRGateway.ps1"
    #authorization_key       = try(local.combined_objects_data_factory_integration_runtime_self_hosted[each.integration_runtime.key].primary_authorization_key, null)
  }

}


data_factory = {
  df1 = {
    name = "adf-int"
    resource_group = {
      key = "integration"
      #lz_key = ""
      #name = ""
    }
    managed_virtual_network_enabled = "true"
    private_endpoints = {
      # Require enforce_private_link_endpoint_network_policies set to true on the subnet
      df1-factory = {
        name               = "adf-int-acct"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "integration"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "adf-int-acct"
          is_manual_connection = false
          subresource_names    = ["dataFactory"]
        }
        private_dns = {
          zone_group_name = "privatelink.datafactory.azure.net"
          # lz_key          = ""   # If the DNS keys are deployed in a remote landingzone
          keys = ["privatelink.datafactory.azure.net"]
        }
      }
      df1-portal = {
        name               = "adf-int-portal"
        vnet_key           = "vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "integration"
        private_service_connection = {
          name                 = "adf-int-portal"
          is_manual_connection = false
          subresource_names    = ["portal"]
        }
        private_dns = {
          zone_group_name = "privatelink.adf.azure.com"
          # lz_key          = ""   # If the DNS keys are deployed in a remote landingzone
          keys = ["privatelink.adf.azure.com"]
        }
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_data_factory"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}

data_factory_integration_runtime_self_hosted = {
  dfirsh1 = {
    name = "adfsharedshir"
    resource_group = {
      key = "integration"
    }
    data_factory = {
      key = "df1"
    }
  }
}
