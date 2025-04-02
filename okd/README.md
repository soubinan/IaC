# Setup and Manage an OKD cluster

## Deploy OKD

### Assisted local installation

Use the pull secret below if you do not plan to use a real one

```json
{"auths":{"fake":{"auth":"aWQ6cGFzcwo="}}}
```

### Manual installation

```sh {"interpreter":"/bin/bash"}
# Get CLI and cluster versions
oc version
```

```sh {"interpreter":"/bin/bash"}
OKD_VERSION=$(curl -s https://api.github.com/repos/okd-project/okd-scos/releases/latest | jq -r '.tag_name')
curl -sL https://github.com/okd-project/okd-scos/releases/download/${OKD_VERSION}/openshift-client-linux-${OKD_VERSION}.tar.gz | sudo tar xvz -C /usr/local/bin/ oc
curl -sL https://github.com/okd-project/okd-scos/releases/download/${OKD_VERSION}/openshift-install-linux-${OKD_VERSION}.tar.gz | sudo tar xvz -C /usr/local/bin/ openshift-install
echo Done
```

```sh {"interpreter":"/bin/bash"}
rm -rf sno
cp -r sno_ sno
openshift-install --dir=sno create single-node-ignition-config
```

```sh {"interpreter":"/bin/bash"}
OKD_BUILD_ID=$(curl -s https://okd-scos.s3.amazonaws.com/okd-scos/builds/builds.json | jq -r .builds[0].id)
echo $OKD_BUILD_ID
OKD_BUILD_ID=414.9.202401231453-0
echo $OKD_BUILD_ID
wget https://okd-scos.s3.amazonaws.com/okd-scos/builds/${OKD_BUILD_ID}/x86_64/scos-${OKD_BUILD_ID}-live.x86_64.iso
```

```sh {"interpreter":"/bin/bash"}
wget $(openshift-install coreos print-stream-json |jq -r .architectures.x86_64.artifacts.metal.formats.iso.disk.location) -O fcos-live.iso
```

```sh {"interpreter":"/bin/bash"}
alias coreos-installer='podman run --privileged --pull always --rm -v /dev:/dev -v /run/udev:/run/udev -v $PWD:/data -w /data quay.io/coreos/coreos-installer:release'
coreos-installer iso ignition embed -fi sno/bootstrap-in-place-for-live-iso.ign fcos-live.iso
```

## Setup ArgoCD local environment

### Download CLI latest version

```sh {"interpreter":"/bin/bash"}
VERSION=$(curl -sL https://developers.redhat.com/content-gateway/rest/browse/pub/openshift-v4/clients/openshift-gitops/ |grep -v latest | htmlq 'tr a' --attribute href | cut -d / -f 11 | tail -n 1)
curl -sSL -o /tmp/argocd-linux-amd64 https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/openshift-gitops/${VERSION}/argocd-linux-amd64
sudo install -m 555 /tmp/argocd-linux-amd64 /usr/local/bin/argocd
rm /tmp/argocd-linux-amd64
echo Done

```

### Log into the ArgoCD instance

```sh {"interpreter":"/bin/bash"}
SERVER_URL=$(oc get routes openshift-gitops-server -n openshift-gitops -o jsonpath='{.status.ingress[0].host}')

argocd login ${SERVER_URL} --skip-test-tls --grpc-web --sso
argocd version
```