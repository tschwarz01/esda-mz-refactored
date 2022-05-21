global_settings = {
  inherit_tags   = true
  passthrough    = false
  random_length  = 4
  default_region = "region1"
  regions = {
    region1 = "southcentralus"
    region2 = "centralus"
  }
  tags = {
    Owner   = "Cloud Scale Analytics Scenario"
    Project = "Cloud Scale Analytics Scneario"
    Toolkit = "Terraform"
  }
}

resource_groups = {
  automation = {
    name          = "automation"
    location      = "region1"
    should_create = true
  }
  integration = {
    name          = "integration"
    location      = "region1"
    should_create = true
  }
  governance = {
    name          = "governance"
    location      = "region1"
    should_create = true
  }
  consumption = {
    name          = "consumption"
    location      = "region1"
    should_create = true
  }
  logmgmt = {
    name          = "logging-and-management"
    location      = "region1"
    should_create = true
  }
  marketplace = {
    name          = "marketplace"
    location      = "region1"
    should_create = true
  }
  meshservice = {
    name          = "mesh-service"
    location      = "region1"
    should_create = true
  }
  network = {
    name          = "networking"
    location      = "region1"
    should_create = true
  }
  sharedservices = {
    name          = "shared-services"
    location      = "region1"
    should_create = true
  }
}


vnets = {
  vnet_region1 = {
    resource_group_key = "network"
    vnet = {
      name          = "dmlz-networking"
      address_space = ["10.11.0.0/21"]
    }
    subnets = {
      cicd = {
        name          = "cicd-iaas-agents-subnet"
        cidr          = ["10.11.0.128/26"]
        should_create = true
      }
      /*
      aci = {
        name          = "aci"
        cidr          = ["10.11.0.192/26"]
        should_create = true
        delegation = {
          name               = "acidelegation"
          service_delegation = "Microsoft.ContainerInstance/containerGroups"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/action"
          ]
        }
      }
      */
      services = {
        name              = "services"
        cidr              = ["10.11.1.0/24"]
        service_endpoints = ["Microsoft.KeyVault"]
        should_create     = true
      }
      private_endpoints = {
        name                                           = "private-endpoints"
        cidr                                           = ["10.11.6.0/24"]
        enforce_private_link_endpoint_network_policies = true
        should_create                                  = true
      }
      bastion = {
        name          = "AzureBastionSubnet"
        cidr          = ["10.11.2.0/25"]
        should_create = true
        nsg_key       = "azure_bastion_nsg"
      }
      pbi_vnet_gateway = {
        name          = "PowerPlatform-Vnet-Gateway"
        cidr          = ["10.11.2.128/25"]
        should_create = true
        delegation = {
          name               = "power-platform-delegation"
          service_delegation = "Microsoft.PowerPlatform/vnetaccesslinks"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        }
      }
    }
    special_subnets = {
      AzureFirewallSubnet = {
        name          = "AzureFirewallSubnet" # must be named AzureFirewallSubnet
        cidr          = ["10.11.0.0/26"]
        should_create = true
      }
      GatewaySubnet = {
        name          = "GatewaySubnet" # must be named GatewaySubnet
        cidr          = ["10.11.0.64/26"]
        should_create = false
      }
    }
    diagnostic_profiles = {
      operation = {
        definition_key   = "networking_all"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}

network_watchers = {
  network_watcher_1 = {
    name               = "nwatcher_scus"
    resource_group_key = "lz_vnet_region1"
    region             = "region1"
  }
}

vnet_peerings_v1 = {
  dmlz_to_hub = {
    name = "dmlz_to_region1_connectivity_hub"
    from = {
      vnet_key = "vnet_region1"
    }
    to = {
      id = "/subscriptions/893395a4-65a3-4525-99ea-2378c6e0dbed/resourceGroups/rg-network_connectivity_hub/providers/Microsoft.Network/virtualNetworks/vnet-connectivity_hub"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
  hub_to_dmlz = {
    name = "region1_connectivity_hub_to_dmlz"
    from = {
      id = "/subscriptions/893395a4-65a3-4525-99ea-2378c6e0dbed/resourceGroups/rg-network_connectivity_hub/providers/Microsoft.Network/virtualNetworks/vnet-connectivity_hub"
    }
    to = {
      vnet_key = "vnet_region1"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}

public_ip_addresses = {
  bastion_host = {
    name                    = "bastion-pip1"
    resource_group_key      = "sharedservices"
    sku                     = "Standard"
    allocation_method       = "Static"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"

    diagnostic_profiles = {
      operation = {
        definition_key   = "public_ip_address"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
  lb_pip1 = {
    name                    = "lb_pip1"
    resource_group_key      = "integration"
    sku                     = "Basic"
    allocation_method       = "Dynamic"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"

    diagnostic_profiles = {
      operation = {
        definition_key   = "public_ip_address"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
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
    diagnostic_profiles = {
      operation = {
        definition_key   = "load_balancer"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}

bastion_hosts = {
  bastion_hub = {
    name               = "mz_bastion-001"
    region             = "region1"
    resource_group_key = "logmgmt"
    vnet_key           = "vnet_region1"
    subnet_key         = "bastion"
    public_ip_key      = "bastion_host"
    diagnostic_profiles = {
      operations = {
        definition_key   = "bastion_host"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}

#
# Definition of the networking security groups
#
network_security_group_definition = {
  # This entry is applied to all subnets with no NSG defined
  empty_nsg = {
    version            = 1
    resource_group_key = "network"
    name               = "empty_nsg"
    /*
    flow_logs = {
      version = 2
      enabled = true
      storage_account = {
        storage_account_destination = "all_regions"
        retention = {
          enabled = true
          days    = 30
        }
      }
      traffic_analytics = {
        enabled                             = true
        log_analytics_workspace_destination = "central_logs"
        interval_in_minutes                 = "10"
      }
    }
    */
    diagnostic_profiles = {
      nsg = {
        definition_key   = "network_security_group"
        destination_type = "storage"
        destination_key  = "all_regions"
      }
      operations = {
        name             = "operations"
        definition_key   = "network_security_group"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    nsg = []
  }

  azure_bastion_nsg = {
    version            = 1
    resource_group_key = "network"
    name               = "azure_bastion_nsg"

    diagnostic_profiles = {
      nsg = {
        definition_key   = "network_security_group"
        destination_type = "storage"
        destination_key  = "all_regions"
      }
      operations = {
        name             = "operations"
        definition_key   = "network_security_group"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    nsg = [
      {
        name                       = "AllowWebExperienceInBound",
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowControlPlaneInBound",
        priority                   = "110"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowHealthProbesInBound",
        priority                   = "120"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowBastionHostToHostInBound",
        priority                   = "130"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_ranges    = ["8080", "5701"]
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "DenyAllInBound",
        priority                   = "1000"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowSshToVnetOutBound",
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "AllowRdpToVnetOutBound",
        priority                   = "110"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "AllowControlPlaneOutBound",
        priority                   = "120"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "AzureCloud"
      },
      {
        name                       = "AllowBastionHostToHostOutBound",
        priority                   = "130"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["8080", "5701"]
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "AllowBastionCertificateValidationOutBound",
        priority                   = "140"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "Internet"
      },
      {
        name                       = "DenyAllOutBound",
        priority                   = "1000"
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

# existing_private_dns allows you to specify that existing private dns zones, likely deployed in a separate subscription, should be used
existing_private_dns = {
  subscription_id     = "c00669a2-37e9-4e0d-8b57-4e8dd0fcdd4a"
  resource_group_name = "rg-scus-pe-lab-network"
  zones_region        = "region1"
  local_vnet_key      = "vnet_region1"
  dns_zones = [
    "privatelink.blob.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com",
    "privatelink.servicebus.windows.net",
    "privatelink.azurecr.io",
    "privatelink.azuresynapse.net",
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net"
  ]
}

# need to uncomment below if intent is to create local private dns zones
# private_dns will create the specified zones in the management zone (current template) subscription
private_dns = {
  create_private_dns_zones_in_data_management_zone = false
  zones = {
    "privatelink.azurewebsites.net" = {
      name               = "privatelink.azurewebsites.net"
      resource_group_key = "network"
      vnet_links = {
        vnet_link = {
          name     = "vnet_link"
          vnet_key = "vnet_region1"
        }
      }
    }
    "privatelink.documents.azure.com" = {
      name               = "privatelink.documents.azure.com"
      resource_group_key = "network"
      vnet_links = {
        vnet_link = {
          name     = "vnet_link"
          vnet_key = "vnet_region1"
        }
      }
    }
  }
}
