variable "subscription_id" {
  default = "xxxx-xxxxx-xxxxx"
}

variable "location" {
  type        = string
  description = "Azure resources location"
  default     = "WestEurope"
}

variable "product_name" {
  type        = string
  nullable    = false
  description = "(Mandatory) Project/Application name. "
  default     = "PoC"
}

variable "tags" {
  description = "Common tags to be applied to all resources."
  type = map(string)
  default = {
    owner       = "Wael Amer"
    environment = "poc"
    project     = "zurich-q1"
    department  = "IT"
    cost_center = "12345"
  }
}

variable "vnets" {
  description = "Map of VNets to create"
  type = map(object({
    name          = string
    address_space = string
    subnets       = map(object({ address_prefix = string }))
  }))
  default = {
    hub = {
      name          = "hub",
      address_space = "10.0.0.0/14",
      subnets = {
        "snet-Gateway"        = { address_prefix = "10.0.0.0/22" },
        "snet-Firewall"       = { address_prefix = "10.0.4.0/22" },
        "snet-SharedServices" = { address_prefix = "10.0.8.0/22" },
        "snet-Monitoring"     = { address_prefix = "10.0.12.0/22" }
      }
    },
    prod = {
      name          = "prod",
      address_space = "10.4.0.0/14",
      subnets = {
        "snet-Frontend" = { address_prefix = "10.4.0.0/22" },
        "snet-Backend"  = { address_prefix = "10.4.4.0/22" },
        "snet-DB"       = { address_prefix = "10.4.8.0/22" },
        "snet-AKS"      = { address_prefix = "10.4.16.0/21" }
      }
    }
  }
}

locals {
  frontend_subnet_id = element(
    [for subnet in azurerm_virtual_network.vnet-spoke["prod"].subnet : subnet.id if subnet.name == "snet-Frontend"],
    0
  )
  
  backend_subnet_id = element(
    [for subnet in azurerm_virtual_network.vnet-spoke["prod"].subnet : subnet.id if subnet.name == "snet-Backend"],
    0
  )
}
