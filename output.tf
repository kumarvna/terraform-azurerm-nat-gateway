output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, azurerm_resource_group.rg.*.id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = [for k in azurerm_nat_gateway.main : k.id]
}

output "nat_gateway_resource_guid" {
  description = "The resource GUID property of the NAT Gateway"
  value       = [for k in azurerm_nat_gateway.main : k.resource_guid]
}

output "azurerm_nat_gateway_public_ip_association_id" {
  description = "The (Terraform specific) ID of the Association between the Nat Gateway and the Public IP."
  value       = [for k in azurerm_nat_gateway_public_ip_association.main : k.id]
}

output "azurerm_nat_gateway_public_ip_prefix_association_id" {
  description = "The (Terraform specific) ID of the Association between the Nat Gateway and the Public IP Prefix."
  value       = [for k in azurerm_nat_gateway_public_ip_prefix_association.main : k.id]
}
