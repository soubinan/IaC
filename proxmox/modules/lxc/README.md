## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_ansible"></a> [ansible](#requirement\_ansible) | ~> 1.3.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~> 0.69 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ansible"></a> [ansible](#provider\_ansible) | ~> 1.3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | ~> 0.69 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [ansible_playbook.configure_lxc_machine](https://registry.terraform.io/providers/ansible/ansible/latest/docs/resources/playbook) | resource |
| [null_resource.ssh_cleanup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [proxmox_virtual_environment_container.lxc_machine](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container) | resource |
| [proxmox_virtual_environment_download_file.lxc_image](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_playbook"></a> [ansible\_playbook](#input\_ansible\_playbook) | n/a | <pre>object({<br/>    path              = string,<br/>    is_replayable     = bool,<br/>    vars              = map(string),<br/>    disable_ssh_check = bool,<br/>  })</pre> | <pre>{<br/>  "disable_ssh_check": false,<br/>  "is_replayable": true,<br/>  "path": "",<br/>  "vars": {}<br/>}</pre> | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | n/a | `string` | `"amd64"` | no |
| <a name="input_assigned_cores"></a> [assigned\_cores](#input\_assigned\_cores) | n/a | `number` | n/a | yes |
| <a name="input_assigned_memory"></a> [assigned\_memory](#input\_assigned\_memory) | n/a | `number` | n/a | yes |
| <a name="input_assigned_swap"></a> [assigned\_swap](#input\_assigned\_swap) | n/a | `number` | n/a | yes |
| <a name="input_default_suffix"></a> [default\_suffix](#input\_default\_suffix) | n/a | `string` | `"Managed by Terraform"` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `""` | no |
| <a name="input_disks"></a> [disks](#input\_disks) | n/a | <pre>list(object({<br/>    datastore_id = string,<br/>    size         = number,<br/>    }<br/>  ))</pre> | n/a | yes |
| <a name="input_enable_nfs"></a> [enable\_nfs](#input\_enable\_nfs) | n/a | `bool` | `false` | no |
| <a name="input_ip_configs"></a> [ip\_configs](#input\_ip\_configs) | n/a | <pre>list(object({<br/>    ip      = string,<br/>    prefix  = number,<br/>    gateway = string,<br/>    }<br/>  ))</pre> | n/a | yes |
| <a name="input_is_privileged"></a> [is\_privileged](#input\_is\_privileged) | n/a | `bool` | `false` | no |
| <a name="input_lxc_image"></a> [lxc\_image](#input\_lxc\_image) | n/a | <pre>object({<br/>    image_url         = string,<br/>    image_name        = string,<br/>    dst_targeted_node = string,<br/>    dst_datastore_id  = string,<br/>    overwrite         = bool,<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_network_dns"></a> [network\_dns](#input\_network\_dns) | n/a | `list(string)` | n/a | yes |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | n/a | <pre>list(object({<br/>    name   = string,<br/>    bridge = string,<br/>    }<br/>  ))</pre> | <pre>[<br/>  {<br/>    "bridge": "vmbr0",<br/>    "name": "veth0"<br/>  }<br/>]</pre> | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | n/a | `string` | `"debian"` | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | n/a | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `list(string)` | n/a | yes |
| <a name="input_targeted_node"></a> [targeted\_node](#input\_targeted\_node) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
