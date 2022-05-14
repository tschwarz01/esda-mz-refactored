public_ip_addresses = {
  bastion_host = {
    name                    = "bastion-pip1"
    resource_group_key      = "sharedservices"
    sku                     = "Standard"
    allocation_method       = "Static"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"
  }
  lb_pip1 = {
    name               = "lb_pip1"
    resource_group_key = "integration"
    sku                = "Basic"
    # Note: For UltraPerformance ExpressRoute Virtual Network gateway, the associated Public IP needs to be sku "Basic" not "Standard"
    allocation_method = "Dynamic"
    # allocation method needs to be Dynamic
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"
  }
}


# Application security groups
application_security_groups = {
  app_sg1 = {
    resource_group_key = "integration"
    name               = "app_sg1"

  }
}

load_balancers = {
  lb-vmss = {
    name                      = "lb-vmss"
    sku                       = "Basic"
    resource_group_key        = "integration"
    backend_address_pool_name = "vmss1"
    frontend_ip_configurations = {
      config1 = {
        name                  = "config1"
        public_ip_address_key = "lb_pip1"
      }
    }
    probes = {
      probe1 = {
        resource_group_key = "integration"
        load_balancer_key  = "lb-vmss"
        probe_name         = "rdp"
        port               = "3389"
      }
    }
    lb_rules = {
      rule1 = {
        resource_group_key             = "integration"
        load_balancer_key              = "lb-vmss"
        lb_rule_name                   = "rule1"
        protocol                       = "Tcp"
        probe_id_key                   = "probe1"
        frontend_port                  = "3389"
        backend_port                   = "3389"
        frontend_ip_configuration_name = "config1" #name must match the configuration that's defined in the load_balancers block.
      }
    }
  }
}



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
        #custom_data                     = "scripts/installSHIRGateway.ps1"

        rolling_upgrade_policy = {
          #   # Only for upgrade mode = "Automatic / Rolling "
          max_batch_instance_percent              = 60
          max_unhealthy_instance_percent          = 60
          max_unhealthy_upgraded_instance_percent = 60
          pause_time_between_batches              = "PT01M"
        }
        automatic_os_upgrade_policy = {
          # Only for upgrade mode = "Automatic"
          disable_automatic_rollback  = false
          enable_automatic_os_upgrade = false
        }

        os_disk = {
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
          disk_size_gb         = 128
        }

        # Uncomment in case the managed_identity_keys are generated locally
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

        # The health is determined by an exising loadbalancer probe.
        health_probe = {
          loadbalancer_key = "lb-vmss"
          probe_key        = "probe1"
        }

      }
    }

    network_interfaces = {
      nic0 = {
        # Value of the keys from networking.tfvars
        name       = "0"
        primary    = true
        vnet_key   = "vnet_region1"
        subnet_key = "services"
        #subnet_id  = "/subscriptions/97958dac-XXXX-XXXX-XXXX-9f436fa73bd4/resourceGroups/xbvt-rg-vmss-agw-exmp-rg/providers/Microsoft.Network/virtualNetworks/xbvt-vnet-vmss/subnets/xbvt-snet-compute"

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
    ultra_ssd_enabled = false # required if planning to use UltraSSD_LRS



    /*
    virtual_machine_scale_set_extensions = {
      data_factory_self_hosted_integration_runtime = {
        self_hosted_integration_runtime_auth_key = null

        # Key Vault & secret name where the Self-Hosted Integration Runtime authorization key is stored
        vault_settings = {
          secret_name  = "shir-auth-key"
          key_vault_id = null
          lz_key       = "examples"
          keyvault_key = "kv1"
        }

        identity_type             = "UserAssigned" # optional to use managed_identity for download from location specified in fileuri, UserAssigned or SystemAssigned.
        managed_identity_key      = "vmssadf"
        automatic_upgrade_enabled = false

        #########################
        #  base_command_to_execute is used in conjunction with a Self-Hosted Integration Runtime authorization key
        #  retrieved from Azure Key Vault using the vault_settings parameters
        #########################
        base_command_to_execute = "powershell.exe -ExecutionPolicy Unrestricted -File installSHIRGateway.ps1 -gatewayKey"
        #base_command_to_execute   = "powershell.exe -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -command"


        #########################
        #  command_override supercedes base_command_to_execute, allowing
        #  the Self-Hosted Integration Runtime authorization key to be defined inline
        #  or alternative logic implemented
        #########################
        #command_override = "powershell.exe -File C:/pathTo/script.ps1"


        #########################
        # You can define fileuris directly or use fileuri_sa reference keys and lz_key:
        #########################
        fileuris = ["https://raw.githubusercontent.com/Azure/data-landing-zone/main/code/installSHIRGateway.ps1"]
        #fileuri_sa_key          = "sa1"
        #fileuri_sa_path         = "files/installSHIRGateway.ps1"
        #lz_key                    = "examples"
        # managed_identity_id       = "id" # optional to define managed identity principal_id directly
        # lz_key                    = "other_lz" # optional for managed identity defined in other lz
      }
    }
*/
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


dynamic_keyvault_secrets = {
  kv1 = {
    shirKey = {
      # this secret is retrieved automatically from the module run output
      secret_name   = "shir-auth-key"
      output_key    = "data_factory_integration_runtime_self_hosted"
      resource_key  = "dfirsh1"
      attribute_key = "primary_authorization_key"
    }
  }
}
