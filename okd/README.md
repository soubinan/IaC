# Setup and Manage an OKD cluster

## Deploy OKD

### Assisted local installation

Use the pull secret below if you do not plan to use a real one

```json
{"auths":{"fake":{"auth":"aWQ6cGFzcwo="}}}
```

## Install required CLI tools

```sh {"interpreter":"/bin/bash"}
OKD_VERSION=$(curl -s https://api.github.com/repos/okd-project/okd-scos/releases/latest | jq -r '.tag_name')
OKD_BIN_REPO=https://github.com/okd-project/okd-scos/releases/download/${OKD_VERSION}
OKD_BIN_FILES=https://developers.redhat.com/content-gateway
HELM_VERSION=$(curl -sL ${OKD_BIN_FILES}/rest/browse/pub/openshift-v4/clients/helm/ |grep -v latest | htmlq 'tr a' --attribute href | cut -d / -f 11 | sort -t. -k2,2n | tail -n 1)
OKD_BIN_FILES=${OKD_BIN_FILES}/file/pub/openshift-v4/clients

# Openshift client
curl -sL ${OKD_BIN_REPO}/openshift-client-linux-${OKD_VERSION}.tar.gz | sudo tar xz -C /usr/local/bin/ oc
# Helm
curl -sL ${OKD_BIN_FILES}/helm/${HELM_VERSION}/helm-linux-amd64 -o /tmp/helm-linux-amd64
sudo install -m 555 /tmp/helm-linux-amd64 /usr/local/bin/helm
rm /tmp/helm-linux-amd64

echo Done
```

```sh {"interpreter":"/bin/bash"}
# Get CLI and cluster versions
echo "Openshift Client version ======="
oc version --client

echo "HELM version ======="
helm version

echo "Argo CD version ======="
argocd version --client
```

### Log into the ArgoCD instance

```sh {"interpreter":"/bin/bash"}
SERVER_URL=$(oc get routes openshift-gitops-server -n openshift-gitops -o jsonpath='{.status.ingress[0].host}')

argocd login ${SERVER_URL} --skip-test-tls --grpc-web --sso
argocd version
```
