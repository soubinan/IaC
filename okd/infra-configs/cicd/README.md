# Install Argo Workflows

## Install pre-required resources

```sh {"interpreter":"/bin/bash"}
oc apply -f .
```

## Install Helm Chart

```sh {"interpreter":"/bin/bash"}
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

```sh {"interpreter":"/bin/bash"}
helm install argowf argo/argo-workflows -f workflows.values -n argo-workflows --create-namespace
#helm install argoev argo/argo-events -f events.values -n argo-workflows --create-namespace
```

## Install CLI

```sh {"interpreter":"/bin/bash"}
ARGO_VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-workflows/releases/latest | jq -r '.tag_name')

curl -sL https://github.com/argoproj/argo-workflows/releases/download/$ARGO_VERSION/argo-linux-amd64.gz -o /tmp/argo-linux-amd64.gz
gunzip /tmp/argo-linux-amd64.gz
sudo install -m 555 /tmp/argo-linux-amd64 /usr/local/bin/argo
rm /tmp/argo-linux-amd64*

echo Done

```

```sh {"interpreter":"/bin/bash"}
argo version
```