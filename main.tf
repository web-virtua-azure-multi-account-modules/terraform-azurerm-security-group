locals {
  tags_security_group = {
    "tf-name" = var.name
    "tf-type" = "sec-group"
  }

  ports_normalize = flatten([
    for index, port in [3000, "4000, 4005", "5000 - 5006", "6000-7000"] : [
      replace(replace(port, " ", ""), ",", "-")
    ]
  ])

  rules = flatten([
    for index, item in var.security_rules : [item.type == "stateful" ? [
      {
        name                                       = "${item.name}-in"
        access                                     = item.access
        direction                                  = "Inbound"
        protocol                                   = contains(["-1", "all", "All", "*"], item.protocol) ? "*" : title(item.protocol)
        priority                                   = item.priority != null ? item.priority : index + 100
        description                                = item.description
        source_address_prefix                      = length(item.source_adresses) == 1 ? contains(["-1", "all", "All", "*"], item.source_adresses[0]) ? "*" : item.source_adresses[0] : null
        source_address_prefixes                    = length(item.source_adresses) >= 2 ? item.source_adresses : null
        destination_address_prefix                 = length(item.destination_adresses) == 1 ? contains(["-1", "all", "All", "*"], item.destination_adresses[0]) ? "*" : item.destination_adresses[0] : null
        destination_address_prefixes               = length(item.destination_adresses) >= 2 ? item.destination_adresses : null
        source_application_security_group_ids      = item.source_application_security_group_ids
        destination_application_security_group_ids = item.destination_application_security_group_ids
        destination_port_range                     = length(item.destination_ports) == 1 ? contains(["-1", "all", "All", "*"], item.destination_ports[0]) ? "*" : replace(replace(item.destination_ports[0], " ", ""), ",", "-") : null
        source_port_range                          = length(item.source_ports) == 1 ? contains(["-1", "all", "All", "*"], item.source_ports[0]) ? "*" : replace(replace(item.source_ports[0], " ", ""), ",", "-") : null

        destination_port_ranges = length(item.destination_ports) >= 2 ? flatten([
          for index, port in item.destination_ports : [
            replace(replace(port, " ", ""), ",", "-")
          ]
        ]) : null

        source_port_ranges = length(item.source_ports) >= 2 ? flatten([
          for index, port in item.source_ports : [
            replace(replace(port, " ", ""), ",", "-")
          ]
        ]) : null
      },
      {
        name                                       = "${item.name}-out"
        access                                     = item.access
        direction                                  = "Outbound"
        protocol                                   = contains(["-1", "all", "All", "*"], item.protocol) ? "*" : title(item.protocol)
        priority                                   = item.priority != null ? item.priority : index + 100
        description                                = item.description
        source_address_prefix                      = length(item.source_adresses) == 1 ? contains(["-1", "all", "All", "*"], item.source_adresses[0]) ? "*" : item.source_adresses[0] : null
        source_address_prefixes                    = length(item.source_adresses) >= 2 ? item.source_adresses : null
        destination_address_prefix                 = length(item.destination_adresses) == 1 ? contains(["-1", "all", "All", "*"], item.destination_adresses[0]) ? "*" : item.destination_adresses[0] : null
        destination_address_prefixes               = length(item.destination_adresses) >= 2 ? item.destination_adresses : null
        source_application_security_group_ids      = item.source_application_security_group_ids
        destination_application_security_group_ids = item.destination_application_security_group_ids
        destination_port_range                     = length(item.destination_ports) == 1 ? contains(["-1", "all", "All", "*"], item.destination_ports[0]) ? "*" : replace(replace(item.destination_ports[0], " ", ""), ",", "-") : null
        source_port_range                          = length(item.source_ports) == 1 ? contains(["-1", "all", "All", "*"], item.source_ports[0]) ? "*" : replace(replace(item.source_ports[0], " ", ""), ",", "-") : null

        destination_port_ranges = length(item.destination_ports) >= 2 ? flatten([
          for index, port in item.destination_ports : [
            replace(replace(port, " ", ""), ",", "-")
          ]
        ]) : null

        source_port_ranges = length(item.source_ports) >= 2 ? flatten([
          for index, port in item.source_ports : [
            replace(replace(port, " ", ""), ",", "-")
          ]
        ]) : null
      }] : [
      {
        name                                       = item.name
        access                                     = item.access
        direction                                  = contains(["ingress", "Inbound", "inbound"], item.type) ? "Inbound" : contains(["egress", "Outbound", "outbound"], item.type) ? "Outbound" : null
        protocol                                   = contains(["-1", "all", "All", "*"], item.protocol) ? "*" : title(item.protocol)
        priority                                   = item.priority != null ? item.priority : index + 100
        description                                = item.description
        source_address_prefix                      = length(item.source_adresses) == 1 ? contains(["-1", "all", "All", "*"], item.source_adresses[0]) ? "*" : item.source_adresses[0] : null
        source_address_prefixes                    = length(item.source_adresses) >= 2 ? item.source_adresses : null
        destination_address_prefix                 = length(item.destination_adresses) == 1 ? contains(["-1", "all", "All", "*"], item.destination_adresses[0]) ? "*" : item.destination_adresses[0] : null
        destination_address_prefixes               = length(item.destination_adresses) >= 2 ? item.destination_adresses : null
        source_application_security_group_ids      = item.source_application_security_group_ids
        destination_application_security_group_ids = item.destination_application_security_group_ids
        destination_port_range                     = length(item.destination_ports) == 1 ? contains(["-1", "all", "All", "*"], item.destination_ports[0]) ? "*" : replace(replace(item.destination_ports[0], " ", ""), ",", "-") : null
        source_port_range                          = length(item.source_ports) == 1 ? contains(["-1", "all", "All", "*"], item.source_ports[0]) ? "*" : replace(replace(item.source_ports[0], " ", ""), ",", "-") : null

        destination_port_ranges = length(item.destination_ports) >= 2 ? flatten([
          for index, port in item.destination_ports : [
            replace(replace(port, " ", ""), ",", "-")
          ]
        ]) : null

        source_port_ranges = length(item.source_ports) >= 2 ? flatten([
          for index, port in item.source_ports : [
            replace(replace(port, " ", ""), ",", "-")
          ]
        ]) : null
      }]
    ]
  ])
}

data "azurerm_resource_group" "get_resource_group" {
  name = var.resource_group_name
}

resource "azurerm_network_security_group" "create_security_group" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.get_resource_group.name
  location            = data.azurerm_resource_group.get_resource_group.location
  tags                = merge(var.tags, var.use_tags_default ? local.tags_security_group : {})

  dynamic "security_rule" {
    for_each = local.rules
    iterator = item

    content {
      name                                       = item.value.name
      access                                     = item.value.access
      direction                                  = item.value.direction
      protocol                                   = item.value.protocol
      priority                                   = item.value.priority
      description                                = item.value.description
      source_port_range                          = item.value.source_port_range
      source_port_ranges                         = item.value.source_port_ranges
      destination_port_range                     = item.value.destination_port_range
      destination_port_ranges                    = item.value.destination_port_ranges
      source_address_prefix                      = item.value.source_address_prefix
      source_address_prefixes                    = item.value.source_address_prefixes
      destination_address_prefix                 = item.value.destination_address_prefix
      destination_address_prefixes               = item.value.destination_address_prefixes
      source_application_security_group_ids      = item.value.source_application_security_group_ids
      destination_application_security_group_ids = item.value.destination_application_security_group_ids
    }
  }
}
