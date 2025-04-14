# Install Argo CD

## Install resources

```sh {"interpreter":"/bin/bash"}
oc apply -f .
```

## Install CLI

```sh {"interpreter":"/bin/bash"}
OKD_BIN_FILES=https://developers.redhat.com/content-gateway
ARGOCD_VERSION=$(curl -sL ${OKD_BIN_FILES}/rest/browse/pub/openshift-v4/clients/openshift-gitops/ |grep -v latest | htmlq 'tr a' --attribute href | cut -d / -f 11 | sort -t. -k2,2n | tail -n 1)
OKD_BIN_FILES=${OKD_BIN_FILES}/file/pub/openshift-v4/clients

curl -sL ${OKD_BIN_FILES}/openshift-gitops/${ARGOCD_VERSION}/argocd-linux-amd64 -o /tmp/argocd-linux-amd64
sudo install -m 555 /tmp/argocd-linux-amd64 /usr/local/bin/argocd
rm /tmp/argocd-linux-amd64

echo Done

```