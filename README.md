# IaC

## SoubiLabs Homelab Infrastructure

### How to use terraform configurations

Terraform configs present in this project except cloudflare are executed locally.

Cloudflare configurations are executed remotely on [Hashicorp Cloud Platform](https://app.terraform.io/).

To run the terraform configurations, set your credentials in an env file (.envrc), check example.envrc as an example you could take inspiration on.

### OKD configurations

The OKD configurations are for the operations only (all about the cluster deployment and configs).
Development related configurations are not included and are expected to be in dedicated repositories.
