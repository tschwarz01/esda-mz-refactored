global_settings = {
  passthrough    = false
  random_length  = 4
  default_region = "region1"
  regions = {
    region1 = "southcentralus"
    region2 = "centralus"
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
    name          = "marketpalce"
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
  privatedns = {
    name          = "private-dns-zones"
    location      = "region1"
    should_create = true
  }
  service = {
    name          = "service"
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
      address_space = ["10.12.0.0/21"]
    }
    subnets = {
      cicd = {
        name          = "cicd-iaas-agents-subnet"
        cidr          = ["10.12.0.128/26"]
        should_create = true
        nsg_key       = "empty_nsg"
      }
      aci = {
        name          = "aci"
        cidr          = ["10.12.0.192/26"]
        should_create = true
        nsg_key       = "empty_nsg"
        delegation = {
          name               = "acidelegation"
          service_delegation = "Microsoft.ContainerInstance/containerGroups"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/action"
          ]
        }
      }
      services = {
        name              = "services"
        cidr              = ["10.12.1.0/24"]
        service_endpoints = ["Microsoft.KeyVault"]
        should_create     = true
        nsg_key           = "empty_nsg"
      }
      private_endpoints = {
        name                                           = "private-endpoints"
        cidr                                           = ["10.12.6.0/24"]
        enforce_private_link_endpoint_network_policies = true
        should_create                                  = true
        nsg_key                                        = "empty_nsg"
      }
      bastion = {
        name          = "AzureBastionSubnet"
        cidr          = ["10.12.2.0/25"]
        should_create = true
        nsg_key       = "azure_bastion_nsg"
      }
    }
    special_subnets = {
      AzureFirewallSubnet = {
        name          = "AzureFirewallSubnet" # must be named AzureFirewallSubnet
        cidr          = ["10.12.0.0/26"]
        should_create = true
      }
      GatewaySubnet = {
        name          = "GatewaySubnet" # must be named GatewaySubnet
        cidr          = ["10.12.0.64/26"]
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
  }
  lb_pip1 = {
    name                    = "lb_pip1"
    resource_group_key      = "integration"
    sku                     = "Basic"
    allocation_method       = "Dynamic"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"
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

bastion_hosts = {
  bastion_hub = {
    name               = "mz_bastion-001"
    region             = "region1"
    resource_group_key = "sharedservices"
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

  azure_bastion_nsg = {
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

diagnostic_log_analytics = {
  central_logs_region1 = {
    region             = "region1"
    name               = "logs"
    resource_group_key = "logmgmt"
    solutions_maps = {
      NetworkMonitoring = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/NetworkMonitoring"
      },
      ADAssessment = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ADAssessment"
      },
      ADReplication = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ADReplication"
      },
      AgentHealthAssessment = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/AgentHealthAssessment"
      },
      DnsAnalytics = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/DnsAnalytics"
      },
      ContainerInsights = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ContainerInsights"
      },
      KeyVaultAnalytics = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/KeyVaultAnalytics"
      }
    }
  }
}

diagnostic_storage_accounts = {
  bootdiag1 = {
    name                     = "bootdiag1"
    resource_group_key       = "integration"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
  }
}

diagnostics_destinations = {
  # Storage keys must reference the azure region name
  log_analytics = {
    central_logs = {
      log_analytics_key = "central_logs_region1"
    }
  }
}

#
# Define a set of settings for the various type of Azure resources
#

diagnostics_definition = {
  log_analytics = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["Audit", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  default_all = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  bastion_host = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["BastionAuditLogs", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  networking_all = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["VMProtectionAlerts", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  public_ip_address = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["DDoSProtectionNotifications", true, false, 7],
        ["DDoSMitigationFlowLogs", true, false, 7],
        ["DDoSMitigationReports", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  load_balancer = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        ["LoadBalancerAlertEvent", true, false, 7],
        ["LoadBalancerProbeHealthStatus", true, false, 7],
      ]
      metric = [
        ["AllMetrics", true, false, 7]
      ]
    }
  }

  network_security_group = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["NetworkSecurityGroupEvent", true, false, 7],
        ["NetworkSecurityGroupRuleCounter", true, false, 7],
      ]
    }
  }

  network_interface_card = {
    name = "operational_logs_and_metrics"
    categories = {
      # log = [
      #   # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #   ["AuditEvent", true, false, 7],
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  private_dns_zone = {
    name = "operational_logs_and_metrics"
    categories = {
      # log = [
      #   # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #   ["AuditEvent", true, false, 7],
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_container_registry = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ContainerRegistryRepositoryEvents", true, false, 7],
        ["ContainerRegistryLoginEvents", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_key_vault = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, false, 7],
        ["AzurePolicyEvaluationDetails", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_data_factory = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ActivityRuns", true, false, 7],
        ["PipelineRuns", true, false, 7],
        ["TriggerRuns", true, false, 7],
        ["SandboxPipelineRuns", true, false, 7],
        ["SandboxActivityRuns", true, false, 7],
        ["SSISPackageEventMessages", true, false, 7],
        ["SSISPackageExecutableStatistics", true, false, 7],
        ["SSISPackageEventMessageContext", true, false, 7],
        ["SSISPackageExecutionComponentPhases", true, false, 7],
        ["SSISPackageExecutionDataStatistics", true, false, 7],
        ["SSISIntegrationRuntimeLogs", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  purview_account = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ScanStatusLogEvent", true, false, 7],
        ["DataSensitivityLogEvent", true, false, 7],
        ["Security", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_kubernetes_cluster = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["kube-apiserver", true, false, 7],
        ["kube-audit", true, false, 7],
        ["kube-audit-admin", true, false, 7],
        ["kube-controller-manager", true, false, 7],
        ["kube-scheduler", true, false, 7],
        ["cluster-autoscaler", true, false, 7],
        ["guard", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_site_recovery = {
    name                           = "operational_logs_and_metrics"
    log_analytics_destination_type = "Dedicated"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AzureBackupReport", true, true, 7],
        ["CoreAzureBackup", true, true, 7],
        ["AddonAzureBackupAlerts", true, true, 7],
        ["AddonAzureBackupJobs", true, true, 7],
        ["AddonAzureBackupPolicy", true, true, 7],
        ["AddonAzureBackupProtectedInstance", true, true, 7],
        ["AddonAzureBackupStorage", true, true, 7],
        ["AzureSiteRecoveryJobs", true, true, 7],
        ["AzureSiteRecoveryEvents", true, true, 7],
        ["AzureSiteRecoveryReplicatedItems", true, true, 7],
        ["AzureSiteRecoveryReplicationStats", true, true, 7],
        ["AzureSiteRecoveryRecoveryPoints", true, true, 7],
        ["AzureSiteRecoveryReplicationDataUploadRate", true, true, 7],
        ["AzureSiteRecoveryProtectedDiskDataChurn", true, true, 30],
      ]
      metric = [
        #["AllMetrics", 60, True],
      ]
    }
  }

  azure_automation = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["JobLogs", true, true, 30],
        ["JobStreams", true, true, 30],
        ["DscNodeStatus", true, true, 30],
      ]
      metric = [
        # ["Category name",  "Metric Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, true, 30],
      ]
    }
  }

  event_hub_namespace = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ArchiveLogs", true, false, 7],
        ["OperationalLogs", true, false, 7],
        ["AutoScaleLogs", true, false, 7],
        ["KafkaCoordinatorLogs", true, false, 7],
        ["KafkaUserErrorLogs", true, false, 7],
        ["EventHubVNetConnectionEvent", true, false, 7],
        ["CustomerManagedKeyUserLogs", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  compliance_all = {
    name = "compliance_logs"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, true, 365],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", false, false, 7],
      ]
    }
  }

  siem_all = {
    name = "siem"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, true, 0],
      ]

      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", false, false, 0],
      ]
    }
  }

  subscription_operations = {
    name = "subscription_operations"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)"]
        ["Administrative", true],
        ["Security", true],
        ["ServiceHealth", true],
        ["Alert", true],
        ["Policy", true],
        ["Autoscale", true],
        ["ResourceHealth", true],
        ["Recommendation", true],
      ]
    }
  }

  subscription_siem = {
    name = "activity_logs_for_siem"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)"]
        ["Administrative", false],
        ["Security", true],
        ["ServiceHealth", false],
        ["Alert", false],
        ["Policy", true],
        ["Autoscale", false],
        ["ResourceHealth", false],
        ["Recommendation", false],
      ]
    }
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
