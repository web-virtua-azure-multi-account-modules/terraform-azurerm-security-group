# Azure Security Group for multiples accounts with Terraform module
* This module simplifies creating and configuring of Security Group across multiple accounts on Azure

* Is possible use this module with one account using the standard profile or multi account using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Criate file provider.tf with the exemple code below:
```hcl
provider "azurerm" {
  alias   = "alias_profile_a"

  features {}
}

provider "azurerm" {
  alias   = "alias_profile_b"

  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}
```


## Features enable of Security Group configurations for this module:

- Security Group

## Usage exemples


### Create Security Group with many different rules

```hcl
module "security_group_test" {
  source = "web-virtua-azure-multi-account-modules/security-group/azurerm"

  name                = "security-group-test"
  resource_group_name = var.resource_group_name

  security_rules = [
    {
      name         = "tf-test-sg-1"
      access       = "Deny"
      type         = "ingress"
      protocol     = "all"
      source_ports = ["all"]
    },
    {
      name            = "tf-test-sg-2"
      access          = "Allow"
      type            = "egress"
      protocol        = "tcp"
      source_ports    = ["3000, 3005"]
      source_adresses = ["3.218.27.135/32", "177.30.66.137/32"]
      destination_ports = [100, 200]
      destination_adresses = ["0.0.0.0/0"]
    },
    {
      name            = "tf-test-sg-3"
      type            = "egress"
      protocol        = "tcp"
      source_ports    = ["3000-3005", 88]
      source_adresses = ["3.218.27.135/32", "177.30.66.137/32"]
      description     = "Ports range"
    },
    {
      name            = "tf-test-sg-4"
      type            = "ingress"
      protocol        = "udp"
      source_ports    = [22, 80, 443]
      source_adresses = ["3.218.27.199/32"]
      destination_ports = [100, 200]
      destination_adresses = ["0.0.0.0/0"]
      description     = "SSH and Internet"
    },
    {
      name            = "tf-test-sg-5"
      type            = "stateful"
      protocol        = "tcp"
      source_ports    = ["22"]
      source_adresses = ["3.218.27.135/32"]
      description     = "22 SSH"
    },
  ]

  providers = {
    azurerm = azurerm.alias_profile_b
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| name | `string` | `-` | yes | Secutiry group | `-` |
| resource_group_name | `string` | `-` | yes | Resource group name | `-` |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default to resources | `*`false <br> `*`true |
| tags | `map(any)` | `{}` | no | Tags to secutiry group | `-` |
| security_rules | `list(object)` | `[]` | no | Security rules to subnet | `-` |


## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.create_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group.html) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `security_group` | Security group |
| `security_group_id` | Security group ID |
| `security_rules` | Security group rules |
