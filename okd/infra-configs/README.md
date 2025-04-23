# Manage an OKD cluster

## Install required CLI tools

```sh {"interpreter":"/bin/bash"}
OKD_VERSION=$(curl -s https://api.github.com/repos/okd-project/okd-scos/releases/latest | jq -r '.tag_name')
OKD_BIN_REPO=https://github.com/okd-project/okd-scos/releases/download/${OKD_VERSION}
OKD_BIN_FILES=https://developers.redhat.com/content-gateway
HELM_VERSION=$(curl -sL ${OKD_BIN_FILES}/rest/browse/pub/openshift-v4/clients/helm/ |grep -v latest | htmlq 'tr a' --attribute href | cut -d / -f 11 | sort -t. -k2,2n | tail -n 1)
OKD_BIN_FILES=${OKD_BIN_FILES}/file/pub/openshift-v4/clients

# Openshift client
curl -sL ${OKD_BIN_REPO}/openshift-client-linux-${OKD_VERSION}.tar.gz | sudo tar xvz -C /usr/local/bin/ oc

# Helm
curl -sL ${OKD_BIN_FILES}/helm/${HELM_VERSION}/helm-linux-amd64 -o /tmp/helm-linux-amd64
sudo install -vm 555 /tmp/helm-linux-amd64 /usr/local/bin/helm
rm /tmp/helm-linux-amd64
echo Done
```

```sh {"interpreter":"/bin/bash"}
# Check installed versions
echo "Openshift Client version ======="
oc version --client
echo "HELM version ======="
helm version
echo "Argo CD version ======="
argocd version --client
```

## Notes about Storage

> Ensure you have the right serials as show below.
>
> It should be performed on the real server (using ssh core@<server_ip>)

```txt
[core@okd ~]$ lsblk -o NAME,SIZE,FSUSED,TYPE,MODEL,SERIAL
NAME     SIZE FSUSED TYPE MODEL         SERIAL
sda      1.6T  57.5G disk PERC H330 Adp 00425e16a49e38922f0086f557f098cd
sdb    223.5G        disk DELLBOSS VD   351868f444010010
├─sdb1     1M        part               
├─sdb2   127M        part               
├─sdb3   384M 120.4M part               
└─sdb4   223G  33.5G part               
sdc      3.3T        disk PERC H330 Adp 00f16c9522af51922f0086f557f098cd
```

## Customize Node Configs

```sh {"interpreter":"/bin/bash"}
# Increase Kubelet resources
oc apply -f machine-config/100-kubelet-config.yaml
```

```sh {"interpreter":"/bin/bash"}
# Mount /var/lib/containers to a dedicated disk
podman run --interactive --rm quay.io/coreos/butane:release --pretty \
    --strict < machine-config/100-master-var-lib-containers.bu > machine-config/100-master-var-lib-containers.yaml
oc apply -f machine-config/100-master-var-lib-containers.yaml
```

## Add a pull secret to Openshift

Run the following command using the pull secret you downloaded from OpenShift Cluster Manager to change the cluster’s pull secret.

```sh {"interpreter":"/bin/bash"}
# Assuming /tmp/pull-secret.json contains your pull secret
oc set data secret/pull-secret -n openshift-config \
    --from-file=.dockerconfigjson=/tmp/pull-secret.json
```

If a secret is not already created, run the following command to create the secret.

```sh {"interpreter":"/bin/bash"}
# Assuming /tmp/pull-secret.json contains your pull secret
oc create secret generic pull-secret -n openshift-config \
    --type=kubernetes.io/dockerconfigjson \
    --from-file=.dockerconfigjson=/tmp/pull-secret.json
```

## Enable all catalog sources (Operator Hub)

> This step requires you already added a pull secret. And almost all next steps assume you have it since the operators used are depending on it.

```sh {"interpreter":"/bin/bash"}
oc apply -f operator-hub/sources-config.yaml
```

## Install operators

```sh {"interpreter":"/bin/bash"}
oc apply -f operator-hub/operators/
```

## Setup Vault Secrets Operator

This step require to [install Vault Secrets Operator](#install-operators) first.

You will need to ensure the k8s tokenreview is up to date in Vault.

```sh {"interpreter":"/bin/bash"}
oc apply -f auth-configs/1-vault.yaml
```

## Setup SSO

You will need to ensure the client ID is up to date in auth-configs/sso.yaml#L44

```sh {"interpreter":"/bin/bash"}
oc apply -f auth-configs/sso.yaml
```

## Setup LVM Storage

This step require to [install LVM Storage Operator](#install-operators) first.

```sh {"interpreter":"/bin/bash"}
oc apply -f storage/1-lvm-clusters.yaml
```

## Setup internal S3 Storage

This step require to [install OpenShift Data Foundation Operator](#install-operators) first.

```sh {"interpreter":"/bin/bash"}
# Enable ODF console plugin
oc patch console.operator cluster -n openshift-storage --type json \
    --patch '[{"op": "add", "path": "/spec/plugins", "value": ["odf-console"]}]'
```

```sh {"interpreter":"/bin/bash"}
oc apply -f storage/2-backing-store.yaml
```

## Setup Networking

This step require to [install MetalLB Operator](#install-operators) first.

```sh {"interpreter":"/bin/bash"}
oc apply -f networking/
```

## Setup Cert-Manager

This step require to [install Cert-Manager Operator](#install-operators) and [setup Vault Secrets Operator](#setup-vault-secrets-operator) first.

```sh {"interpreter":"/bin/bash"}
# Deploy Issuer and certificates requests
oc apply -f cert-manager/

# Update Proxy/cluster trustedCA entry
oc patch proxy/cluster --type=merge --patch \
    '{"spec": {"trustedCA": {"name":"trusted-ca"}}}'
```

Once the certificates are issued for apps and the api, we can then update the default ingress controller and the apiserver to use the tls certificates we just created.

```sh {"interpreter":"/bin/bash"}
# Patch default Ingress Controller
oc patch ingresscontroller.operator default --type=merge --patch \
    '{"spec": {"defaultCertificate": {"name": "apps-okd-lab-soubilabs-xyz-tls"}}}' \
    -n openshift-ingress-operator
```

```sh {"interpreter":"/bin/bash"}
# Patch ApiServer
oc patch apiserver cluster --type=merge --patch \
  '{"spec":{"servingCerts": {"namedCertificates": [{"names": ["api.okd.lab.soubilabs.xyz"], "servingCertificate": {"name": "api-okd-lab-soubilabs-xyz-tls"}}]}}}'
```

Check the kube-apiserver operator, and verify that a new revision of the Kubernetes API server rolls out. It may take a minute for the operator to detect the configuration change and trigger a new deployment. While the new revision is rolling out, PROGRESSING will report True.

```sh {"interpreter":"/bin/bash"}
oc get clusteroperators kube-apiserver -w
```

Do not continue to the next step until `PROGRESSING` is listed as `False`.

[More info](https://docs.redhat.com/en/documentation/openshift_container_platform/4.14/html/security_and_compliance/configuring-certificates)

## Setup Virtualization

```sh {"interpreter":"/bin/bash"}
oc apply -f virtualization/hyperconverged.yaml
```

## Setup for GPUs

```sh {"interpreter":"/bin/bash"}
oc apply -f gpus/ndf.yaml
```

```sh {"interpreter":"/bin/bash"}
# Enable IOMMU
podman run --interactive --rm quay.io/coreos/butane:release --pretty \
    --strict < machine-config/100-master-iommu.bu > machine-config/100-master-iommu.yaml
podman run --interactive --rm quay.io/coreos/butane:release --pretty \
    --strict < machine-config/100-master-vfiopci.bu > machine-config/100-master-vfiopci.yaml

oc apply -f machine-config/100-master-iommu.yaml
oc apply -f machine-config/100-master-vfiopci.yaml
```

```sh {"interpreter":"/bin/bash"}
# Annotate GPU nodes
GPU_NODES=$(oc get node -l nvidia.com/gpu.present=true --no-headers | awk '{print $1}')

for gpu_node in $GPU_NODES;
do
oc label node $gpu_node --overwrite nvidia.com/gpu.workload.config=vm-passthrough
done

# Patch HyperConverged for IOMMU
oc apply -f virtualization/hyperconverged-add-gpu-setup.yaml

# Apply GPU operator policy
oc apply -f gpus/cluster-policy.yaml
```

[More info](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/virtualization/managing-vms#virt-configuring-pci-passthrough)

[Download virtctl](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/virtualization/getting-started#installing-virtctl_virt-using-the-cli-tools)

## Setup ArgoCD

```sh {"interpreter":"/bin/bash"}
# Deploy ArgoCD and AppProjects
oc apply -f gitops --overwrite
```

### Install the ArgoCD CLI

```sh {"interpreter":"/bin/bash"}
# Install argocd cli
OKD_BIN_FILES=https://developers.redhat.com/content-gateway
ARGOCD_VERSION=$(curl -sL ${OKD_BIN_FILES}/rest/browse/pub/openshift-v4/clients/openshift-gitops/ |grep -v latest | htmlq 'tr a' --attribute href | cut -d / -f 11 | sort -t. -k2,2n | tail -n 1)
OKD_BIN_FILES=${OKD_BIN_FILES}/file/pub/openshift-v4/clients

curl -sL ${OKD_BIN_FILES}/openshift-gitops/${ARGOCD_VERSION}/argocd-linux-amd64 -o /tmp/argocd-linux-amd64
sudo install -m 555 /tmp/argocd-linux-amd64 /usr/local/bin/argocd
rm /tmp/argocd-linux-amd64

echo Done
```

### Log into the ArgoCD instance

```sh {"interpreter":"/bin/bash"}
SERVER_URL=$(oc get routes openshift-gitops-server -n openshift-gitops -o jsonpath='{.status.ingress[0].host}')

argocd login ${SERVER_URL} --grpc-web --sso
argocd version
```

## Setup Harbor Registry

```sh {"interpreter":"/bin/bash"}
# Deploy static configs first and add helm repo
oc apply -f harbor/
helm repo add harbor https://helm.goharbor.io
helm repo update
```

```sh {"interpreter":"/bin/bash"}
# Deploy helm chart
helm install harbor harbor/harbor -f harbor/harbor.values -n harbor-registry
```

### Grant SCC for Harbor workload

```sh {"interpreter":"/bin/bash"}
oc project harbor-registry

# Copy anyuid to anyuid-seccomp
oc get scc anyuid -o yaml  | sed 's/anyuid/anyuid-seccomp/g;/uid:/d;/creationTimestamp/d;/generation/d;/resourceVersion/d'  | oc create -f -

# Patch the newly create SCC with the seccomp profiles
oc patch scc anyuid-seccomp --type=merge -p '{"seccompProfiles":["runtime/default"]}'

# Once the SCC is modified, assign the SCC to the Service Account
oc adm policy add-scc-to-user anyuid-seccomp -z default
```

[More info](https://access.redhat.com/solutions/7064000)

## Setup the Workflows platform (Argo Workflows + Argo Events)

```sh {"interpreter":"/bin/bash"}
# Deploy static configs first and add helm repo
oc apply -f workflows/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

```sh {"interpreter":"/bin/bash"}
# Deploy Argo Workflows helm chart
helm install argowf argo/argo-workflows -f workflows/workflows.values \
    -n openshift-workflows --create-namespace
```

```sh {"interpreter":"/bin/bash"}
# Try a Workflow test
argo submit https://raw.githubusercontent.com/argoproj/argo-workflows/master/examples/hello-world.yaml --watch --serviceaccount argo-workflow -n workflows
```

```sh {"interpreter":"/bin/bash"}
# Deploy Argo Events helm chart
helm install argoev argo/argo-events -f workflows/events.values \
    -n openshift-workflows --create-namespace
```
