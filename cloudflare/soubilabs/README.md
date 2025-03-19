## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_bot_management.soubilabs_anti_bot](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/bot_management) | resource |
| [cloudflare_dns_record.soubilabs_apex](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_blog](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_blog_star](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_brevo_code](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_brevo_dkim1](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_brevo_dkim2](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_dkim](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_dmarc](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_gh_org](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_mtasts](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_mx_1](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_mx_2](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_mx_3](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_spf](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_tlsrpt](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.soubilabs_www](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_email_routing_address.soubinan_gmail](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/email_routing_address) | resource |
| [cloudflare_email_routing_rule.mail_soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/email_routing_rule) | resource |
| [cloudflare_email_routing_rule.soubinan_soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/email_routing_rule) | resource |
| [cloudflare_email_routing_settings.soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/email_routing_settings) | resource |
| [cloudflare_r2_bucket.lxc_images](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/r2_bucket) | resource |
| [cloudflare_turnstile_widget.soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/turnstile_widget) | resource |
| [cloudflare_worker_route.soubilabs_homelab_lxc_route](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/worker_route) | resource |
| [cloudflare_worker_route.soubilabs_mta_sts_route](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/worker_route) | resource |
| [cloudflare_workers_custom_domain.soubilabs_homelab_lxc](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/workers_custom_domain) | resource |
| [cloudflare_workers_custom_domain.soubilabs_mta_sts](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/workers_custom_domain) | resource |
| [cloudflare_workers_script.homelab_lxc_script](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/workers_script) | resource |
| [cloudflare_workers_script.mta_sts_script](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/workers_script) | resource |
| [cloudflare_zone_dnssec.soubilabs](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_dnssec) | resource |
| [cloudflare_zone_settings_override.soubilabs_zone_settings](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_settings_override) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `"f2dda9cf92c02eb24ced3b63332b6055"` | no |
| <a name="input_soubilabs_domain"></a> [soubilabs\_domain](#input\_soubilabs\_domain) | n/a | `string` | `"soubilabs.xyz"` | no |
| <a name="input_soubilabs_zone_id"></a> [soubilabs\_zone\_id](#input\_soubilabs\_zone\_id) | ###### soubilabs ZONE | `string` | `"4c0aeed8407334470ead0551c57e3cd3"` | no |

## Outputs

No outputs.
