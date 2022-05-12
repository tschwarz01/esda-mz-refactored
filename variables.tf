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

variable "log_analytics" {
  description = "Configuration object - Log Analytics resources."
  default     = {}
}

variable "existing_private_dns" {
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
