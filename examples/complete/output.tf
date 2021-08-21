output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = module.nat-gateway.resource_group_name
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = module.nat-gateway.resource_group_id
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = module.nat-gateway.resource_group_location
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.nat-gateway.nat_gateway_id
}

output "nat_gateway_resource_guid" {
  description = "The resource GUID property of the NAT Gateway"
  value       = module.nat-gateway.nat_gateway_resource_guid
}

output "azurerm_nat_gateway_public_ip_association_id" {
  description = "The (Terraform specific) ID of the Association between the Nat Gateway and the Public IP."
  value       = module.nat-gateway.azurerm_nat_gateway_public_ip_association_id
}

output "azurerm_nat_gateway_public_ip_prefix_association_id" {
  description = " The (Terraform specific) ID of the Association between the Nat Gateway and the Public IP Prefix."
  value       = module.nat-gateway.azurerm_nat_gateway_public_ip_prefix_association_id
}
