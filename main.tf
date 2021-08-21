#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  nat_gateway_zones   = { for zone in var.nat_gateway_zones : zone => true }
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
}

data "azurerm_log_analytics_workspace" "logws" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = local.resource_group_name
}

data "azurerm_storage_account" "storeacc" {
  count               = var.storage_account_name != null ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = local.resource_group_name
}

#--------------------------------------------
# Public IP resources for Azure NAT Gateway
#--------------------------------------------
resource "azurerm_public_ip_prefix" "ng-pref" {
  for_each            = var.nat_gateway
  name                = lower("${each.key}-pip-prefix")
  resource_group_name = local.resource_group_name
  location            = local.location
  prefix_length       = lookup(each.value, "public_ip_prefix_length", 30)
  availability_zone   = element(coalescelist(each.value["availability_zone"], [""]), 0)
  tags                = merge({ "ResourceName" = lower("${each.key}-pip-prefix") }, var.tags, )
}

resource "azurerm_public_ip" "ng-pip" {
  for_each            = var.nat_gateway
  name                = lower("${each.key}-nat-gateway-pip")
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = element(coalescelist(each.value["availability_zone"], [""]), 0)
  tags                = merge({ "ResourceName" = lower("${each.key}-nat-gateway-pip") }, var.tags, )
}

#--------------------------------------------
# Azure NAT Gateway configuration 
#--------------------------------------------
resource "azurerm_nat_gateway" "main" {
  for_each                = var.nat_gateway
  name                    = format("%s", each.key)
  resource_group_name     = local.resource_group_name
  location                = local.location
  idle_timeout_in_minutes = lookup(each.value, "idle_timeout_in_minutes", 4)
  sku_name                = "Standard"
  zones                   = each.value["availability_zone"]
  tags                    = merge({ "ResourceName" = format("%s", each.key) }, var.tags, )
}

#-----------------------------------------------------
# Association between a Nat Gateway and a Public IP.
#-----------------------------------------------------
resource "azurerm_nat_gateway_public_ip_association" "main" {
  for_each             = var.nat_gateway
  nat_gateway_id       = azurerm_nat_gateway.main[each.key].id
  public_ip_address_id = azurerm_public_ip.ng-pip[each.key].id
}

#-----------------------------------------------------------
# Association between a Nat Gateway and a Public IP Prefix.
#-----------------------------------------------------------
resource "azurerm_nat_gateway_public_ip_prefix_association" "main" {
  for_each            = var.nat_gateway
  nat_gateway_id      = azurerm_nat_gateway.main[each.key].id
  public_ip_prefix_id = azurerm_public_ip_prefix.ng-pref[each.key].id
}

#-----------------------------------------------------------
# Association between a Nat Gateway and a Public IP Prefix.
#-----------------------------------------------------------
resource "azurerm_subnet_nat_gateway_association" "main" {
  for_each       = var.nat_gateway
  nat_gateway_id = azurerm_nat_gateway.main[each.key].id
  subnet_id      = each.value
}
