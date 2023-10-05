output "security_group" {
  description = "Security group"
  value       = azurerm_network_security_group.create_security_group
}

output "security_group_id" {
  description = "Security group ID"
  value       = azurerm_network_security_group.create_security_group.id
}

output "security_rules" {
  description = "Security group rules"
  value       = azurerm_network_security_group.create_security_group.security_rule
}
