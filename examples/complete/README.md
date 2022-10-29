# Azure NAT Gateway Terraform Module

Virtual Network NAT (network address translation) simplifies outbound-only Internet connectivity for virtual networks. When configured on a subnet, all outbound connectivity uses your specified static public IP addresses. Outbound connectivity is possible without load balancer or public IP addresses directly attached to virtual machines.

This terraform module quickly deploys azure NAT Gateway instance with the assiociation with Public IP, Public IP prefix and with a Subnet within a Virtual Network.

## Module Usage

```hcl
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_subnet" "snet1" {
  name                 = "snet-test"
  virtual_network_name = "vnet-shared-hub-westeurope-001"
  resource_group_name  = "rg-shared-westeurope-01"
}

data "azurerm_subnet" "snet2" {
  name                 = "snet-appgateway"
  virtual_network_name = "vnet-shared-hub-westeurope-001"
  resource_group_name  = "rg-shared-westeurope-01"
}

module "nat-gateway" {
  source  = "kumarvna/nat-gateway/azurerm"
  version = "1.1.0"

  # By default, this module will not create a resource group. Location will be same as existing RG.
  # proivde a name to use an existing resource group, specify the existing resource group name, 
  # set the argument to `create_resource_group = true` to create new resrouce group.
  resource_group_name = "rg-shared-westeurope-01"
  location            = "westeurope"

  # Azure NAT Gateway and associated public IP, ip-prefix, subnets specificationscount
  # Regional or zone isolation with availability zones is supported
  nat_gateway = {
    testnatgateway-zone1 = {
      availability_zone       = ["1"]
      public_ip_prefix_length = 30
      idle_timeout_in_minutes = 10
      subnet_id               = data.azurerm_subnet.snet1.id
    },
    testnatgateway-zone2 = {
      availability_zone       = ["2"]
      public_ip_prefix_length = 30
      idle_timeout_in_minutes = 10
      subnet_id               = data.azurerm_subnet.snet2.id
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
```

## Terraform Usage

To run this example you need to execute following Terraform commands

```hcl
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when you don't need these resources.
