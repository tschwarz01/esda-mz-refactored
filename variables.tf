variable "global_settings" {
  default = {
    passthrough    = false
    random_length  = 4
    default_region = "region1"
    regions = {
      region1 = "southcentralus"
      region2 = "centralus"
    }
  }
}



variable "tenant_id" {
  type        = string
  description = "Azure Active Directory Tenant ID"
  default     = null
}

variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "dmlz"
}

variable "prefix" {
  type        = string
  description = "Specifies the prefix for all resources created in this deployment."
  default     = "dmz"

  validation {
    condition = (
      length(var.prefix) > 1 &&
      length(var.prefix) < 11
    )
    error_message = "The value for var: prefix must be between 2 and 10 characters in length."
  }
}

variable "location" {
  type        = string
  description = "Specifies the location for all resources."
  default     = "southcentralus"
}




#######################################################

variable "resource_groups" {
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "Specifies the tags that you want to apply to all resources."
  default = {
    "tagKey" = "tagValue"
  }
}


variable "vnets" {
  default = {}
}

variable "vnet_peerings_v1" {
  default = {}
}

variable "network_security_group_definition" {
  default = {}
}

## Diagnostics settings
variable "diagnostics_definition" {
  default     = null
  description = "Configuration object - Shared diadgnostics settings that can be used by the services to enable diagnostics."
}

variable "diagnostics_destinations" {
  description = "Configuration object - Describes the destinations for the diagnostics."
  default     = null
}

variable "diagnostic_log_analytics" {
  default = {}
}

variable "diagnostic_storage_accounts" {
  description = ""
  default     = {}
}

variable "log_analytics" {
  description = "Configuration object - Log Analytics resources."
  default     = {}
}

variable "private_dns" {
  default = {}
}

variable "existing_private_dns" {
  default = {}
}

variable "private_dns_vnet_links" {
  default = {}
}

variable "data_factory" {
  default = {}
}

variable "data_factory_integration_runtime_self_hosted" {
  default = {}
}

variable "keyvault_access_policies" {
  default = {}
}

variable "keyvaults" {
  default = {}
}

variable "dynamic_keyvault_secrets" {
  default = {}
}

variable "purview_accounts" {
  default = {}
}

variable "virtual_machine_scale_sets" {
  default = {}
}

variable "managed_identities" {
  default = {}
}

variable "azure_container_registries" {
  default = {}
}

variable "application_security_groups" {
  default = {}
}

variable "public_ip_addresses" {
  default = {}
}

variable "load_balancers" {
  default = {}
}

variable "virtual_machine_scale_set_extensions" {
  default = {}
}

variable "vmss_extensions_custom_script_adf_integration_runtime" {
  default = {}
}

variable "bastion_hosts" {
  default = {}
}

variable "shared_image_galleries" {
  default = {}
}

variable "synapse_privatelink_hubs" {
  default = {}
}
