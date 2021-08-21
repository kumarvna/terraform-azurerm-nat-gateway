# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "nat-gateway" {
  source  = "kumarvna/nat-gateway/azurerm"
  version = "1.0.0"

  # By default, this module will not create a resource group. Location will be same as existing RG.
  # proivde a name to use an existing resource group, specify the existing resource group name, 
  # set the argument to `create_resource_group = true` to create new resrouce group.
  #   # The Subnet must have the name `AzureFirewallSubnet` and the subnet mask must be at least a /26
  resource_group_name = "rg-shared-westeurope-01"
  location            = "westeurope"

  # Azure NAT Gateway and associated public IP, ip-prefix, subnets specificationscount
  # Regional or zone isolation with availability zones is supported
  nat_gateway = {
    testnatgateway1 = {
      availability_zone       = ["1"]
      public_ip_prefix_length = 30
      idle_timeout_in_minutes = 10
      subnet_id               = var.subnet_id
    },
    testnatgateway-zone2 = {
      availability_zone       = ["2"]
      public_ip_prefix_length = 30
      idle_timeout_in_minutes = 10
      subnet_id               = var.subnet_id
    }
  }

  # Adding TAG's to your Azure resources 
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
