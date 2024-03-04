## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 4.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.22.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_bot_management.soubilabs_anti_bot](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/bot_management) | resource |
| [cloudflare_email_routing_address.soubinan_gmail](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/email_routing_address) | resource |
| [cloudflare_email_routing_rule.mail_soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/email_routing_rule) | resource |
| [cloudflare_email_routing_rule.soubinan_soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/email_routing_rule) | resource |
| [cloudflare_email_routing_settings.soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/email_routing_settings) | resource |
| [cloudflare_record.soubilabs_apex](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_blog](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_blog_star](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_brevocode](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_brevodkim](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_dkim](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_dmarc](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_mtasts](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_mx_1](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_mx_2](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_mx_3](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_spf](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_spf_www](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_tlsrpt](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_record.soubilabs_www](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/record) | resource |
| [cloudflare_turnstile_widget.soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/turnstile_widget) | resource |
| [cloudflare_worker_domain.soubilabs_homelab_lxc](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/worker_domain) | resource |
| [cloudflare_worker_domain.soubilabs_mta_sts](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/worker_domain) | resource |
| [cloudflare_worker_route.soubilabs_homelab_lxc_route](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/worker_route) | resource |
| [cloudflare_worker_route.soubilabs_mta_sts_route](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/worker_route) | resource |
| [cloudflare_worker_script.homelab_lxc_script](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/worker_script) | resource |
| [cloudflare_worker_script.mta_sts_script](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/worker_script) | resource |
| [cloudflare_zone_dnssec.soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/zone_dnssec) | resource |
| [cloudflare_zone_settings_override.soubilabs_zone_settings](https://registry.terraform.io/providers/cloudflare/cloudflare/4.22/docs/resources/zone_settings_override) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `"f2dda9cf92c02eb24ced3b63332b6055"` | no |
| <a name="input_soubilabs_domain"></a> [soubilabs\_domain](#input\_soubilabs\_domain) | n/a | `string` | `"soubilabs.xyz"` | no |
| <a name="input_soubilabs_zone_id"></a> [soubilabs\_zone\_id](#input\_soubilabs\_zone\_id) | ###### soubilabs ZONE | `string` | `"4c0aeed8407334470ead0551c57e3cd3"` | no |

## Outputs

No outputs.
