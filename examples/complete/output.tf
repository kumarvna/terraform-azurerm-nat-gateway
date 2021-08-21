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
