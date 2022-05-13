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
