output "rg_names" {
  value = [for v in azurerm_resource_group.rg-spoke : v.name]
  description = "The Names of the resourcesgroups for the product"
}
output "vnet_spoke_ids" {
  value       = { for v in azurerm_virtual_network.vnet-spoke : v.name => v.id }
  description = "The IDs of the spoke VNets"
}

output "subnet_ids" {
  value       = { for v in azurerm_virtual_network.vnet-spoke : v.name => [for s in v.subnet : s.id] }
  description = "The IDs of the subnets"
}
