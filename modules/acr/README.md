<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acr-logs"></a> [acr-logs](#module\_acr-logs) | github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting | n/a |
| <a name="module_private_endpoint_nic_logs"></a> [private\_endpoint\_nic\_logs](#module\_private\_endpoint\_nic\_logs) | github.com/ShellyDekel/shelly-hub-and-spoke/log-analytics-diagnostic-setting | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_private_dns_zone.acr_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_endpoint.acr_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | (Required) The name of the ACR. | `string` | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | (Optional) Enable Admin User, (default true). | `bool` | `true` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | (Optional) Name for the Private DNS Zone of the ACR. | `string` | `"privatelink.azurecr.io"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the resource. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Optional) Link resource to a Log Analytics Workspace to enable logs. | `string` | `null` | no |
| <a name="input_private_endpoint_name"></a> [private\_endpoint\_name](#input\_private\_endpoint\_name) | (Optional) Name the Private Endpoint of the ACR. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) The SKU name of the ACR. Possible values are Basic, Standard and Premium. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The ID of the Subnet from which Private IP Addresses will be allocated for this ACR. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | The ACR Admin Password. |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | The ACR Admin Username. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the ACR. |
| <a name="output_name"></a> [name](#output\_name) | The name of the ACR. |
| <a name="output_object"></a> [object](#output\_object) | The ACR object. |
| <a name="output_private_dns_zone"></a> [private\_dns\_zone](#output\_private\_dns\_zone) | The Private DNS Zone object. |
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | The ID of the Private DNS Zone. |
| <a name="output_private_endpoint"></a> [private\_endpoint](#output\_private\_endpoint) | The Private Endpoint object. |
| <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id) | The ID of the Private Endpoint. |
| <a name="output_private_endpoint_name"></a> [private\_endpoint\_name](#output\_private\_endpoint\_name) | The name of the Private Endpoint. |
<!-- END_TF_DOCS -->