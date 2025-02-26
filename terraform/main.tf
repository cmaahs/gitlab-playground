resource "azurerm_resource_group" "env" {
  name     = var.environment
  location = var.location

  tags = local.common_tags
}

module "network" {
  source  = "Azure/network/azurerm"
  version = "~> 3.3.0"

  resource_group_name = var.environment
  vnet_name           = "${var.environment}-vnet"
  address_space       = var.vnet_cidr
  subnet_prefixes     = [var.vnet_subnet_cidr]
  subnet_names        = ["${var.environment}-agents"]

  tags = local.common_tags

  depends_on = [azurerm_resource_group.env]
}

