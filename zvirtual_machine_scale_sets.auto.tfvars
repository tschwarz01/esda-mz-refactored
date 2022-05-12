

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
          enable_automatic_os_upgrade = true
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

  }
}
