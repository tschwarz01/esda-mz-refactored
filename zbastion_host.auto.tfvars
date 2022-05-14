bastion_hosts = {
  bastion_hub = {
    name               = "bastion-001"
    region             = "region1"
    resource_group_key = "sharedservices"
    vnet_key           = "vnet_region1"
    subnet_key         = "bastion"
    public_ip_key      = "bastion_host"

    # you can setup up to 5 profiles
    diagnostic_profiles = {
      operations = {
        definition_key   = "bastion_host"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}

