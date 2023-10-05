variable "name" {
  description = "Subnet name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "use_tags_default" {
  description = "If true will be use the tags default to resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to security group"
  type        = map(any)
  default     = {}
}

variable "security_rules" {
  description = "Security rules to subnet"
  type = list(object({
    name                                       = string                        # The name of the security rule
    access                                     = optional(string, "Allow")     # Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny
    type                                       = optional(string, "ingress")   # The direction specifies, possible values are stateful, ingress, egress, inbound, Inbound, outbound or Outbound. IF the value is stateful will be created one rule inbound and outbound for the same rule
    protocol                                   = optional(string, "*")         # Protocol rules, the possible values are -1, all, All and "*" for all protocols and Tcp, Udp, Icmp, Esp or Ah for other protocols
    priority                                   = optional(number)              # Specifies the priority of the rule. The value can be between 100 and 4096
    description                                = optional(string)              # A description for this rule. Restricted to 140 characters
    source_ports                               = optional(list(any), ["*"])    # List of source ports or port ranges
    destination_ports                          = optional(list(any), ["*"])    # List of destination ports or port ranges
    source_adresses                            = optional(list(string), ["*"]) # List of source address prefixes
    destination_adresses                       = optional(list(string), ["*"]) # List of destination address prefixes
    source_application_security_group_ids      = optional(list(string))        # A List of source Application Security Group IDs
    destination_application_security_group_ids = optional(list(string))        # A List of destination Application Security Group IDs
  }))
  default = []
}
