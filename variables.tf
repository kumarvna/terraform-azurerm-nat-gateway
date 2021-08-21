variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "nat_gateway" {
  description = "Manages Azure NAT Gateway also associated public IP, ip-prefix and subnets"
  type = map(object({
    public_ip_prefix_length = number
    availability_zone       = optional(list(string))
    idle_timeout_in_minutes = optional(number)
    subnet_id               = optional(string)
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
