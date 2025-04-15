# Install Harbor

## Install pre-required resources

```sh {"interpreter":"/bin/bash"}
oc apply -f .
```

## Install Helm Chart

```sh {"interpreter":"/bin/bash"}
helm repo add harbor https://helm.goharbor.io
helm repo update
```

```sh
helm install harbor harbor -f harbor.values -n harbor-registry --create-namespace
```

## Fix Security Context Know Issue

```sh
oc project harbor-registry
```

```sh
# create a new SCC based on the anyuid SCC with the seccompProfile named anyuid-seccomp
oc get scc anyuid -o yaml  | sed 's/anyuid/anyuid-seccomp/g;/uid:/d;/creationTimestamp/d;/generation/d;/resourceVersion/d'  | oc create -f -
oc patch scc anyuid-seccomp --type=merge -p '{"seccompProfiles":["runtime/default"]}'
```

```sh
# Attach anyuid-seccomp to the current namespace default sa
oc adm policy add-scc-to-user anyuid-seccomp -z default
```