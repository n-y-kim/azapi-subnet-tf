# Create test resource group with azurerm
resource "azurerm_resource_group" "rg" {
  name     = "azapi-policy-test-rg"
  location = var.location
}

# VNet 먼저 만든 뒤 별도로 subnet 만드는 경우
resource "azurerm_virtual_network" "vnet" {
  name                = "deny_vnet_later_subnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/8"]
}

resource "azapi_resource" "gateway_subnet" {
    type = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
    name = "GatewaySubnet"
    parent_id = azurerm_virtual_network.vnet.id
    body = jsonencode({
        properties = {
            addressPrefix = "10.0.0.0/24"
        }
    })
}

resource "azurerm_network_security_group" "nsg" {
  name                = "default_nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# NSG가 없을 때 deny 되는 코드

# resource "azapi_resource" "subnet_1" {
#     type = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
#     name = "subnet1"
#     parent_id = azurerm_virtual_network.vnet.id
#     body = jsonencode({
#         properties = {
#             addressPrefix = "10.0.1.0/24",
#         }
#     })
# }

# 일반 subnet

# resource "azapi_resource" "subnet_1" {
#     type = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
#     name = "subnet1"
#     parent_id = azurerm_virtual_network.vnet.id
#     body = jsonencode({
#         properties = {
#             addressPrefix = "10.0.1.0/24",
#             networkSecurityGroup = {
#                 id = azurerm_network_security_group.nsg.id
#             }
#         }
#     })
# }

# subnet 속성 수정 
# 1. privateEndpointNetworkPolicies enable
resource "azapi_resource" "subnet_1" {
    type = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
    name = "subnet1"
    parent_id = azurerm_virtual_network.vnet.id
    body = jsonencode({
        properties = {
            addressPrefix = "10.0.1.0/24",
            networkSecurityGroup = {
                id = azurerm_network_security_group.nsg.id
            }
            # privateEndpointNetworkPolicies 설정
            privateEndpointNetworkPolicies = "Enabled"
        }
    })
}

# 2. routeTable 붙이기
resource "azurerm_route_table" "rt" {
  name                = "route_table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azapi_resource" "subnet_2" {
    type = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
    name = "subnet2"
    parent_id = azurerm_virtual_network.vnet.id
    body = jsonencode({
        properties = {
            addressPrefix = "10.0.2.0/24",
            networkSecurityGroup = {
                id = azurerm_network_security_group.nsg.id
            }
            routeTable = {
                id = azurerm_route_table.rt.id
            }
        }
    })
}