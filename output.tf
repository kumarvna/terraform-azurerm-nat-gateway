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
  description = " The (Terraform specific) ID of the Association between the Nat Gateway and the Public IP Prefix."
  value       = [for k in azurerm_nat_gateway_public_ip_prefix_association.main : k.id]
}