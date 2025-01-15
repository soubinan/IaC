# IaC

## SoubiLabs Homelab Infrastructure

### How to use terraform configurations

Terraform configs present in this project except cloudflare are expected locally.
Cloudflare configurations are executed remotely on the Hashicorp Cloud Platform.
To run the terraform configurations, use the terraform shell script located in the root of the project.

```bash
# An example of how to run the terraform configuration for homarr

cd homarr
. ../terraform init
. ../terraform plan
. ../terraform apply
```

### OKD configurations

The OKD configurations are for the operations only (all about the cluster deployment and configs).
Development related configurations are not included and are expected to be in dedicated repositories.
