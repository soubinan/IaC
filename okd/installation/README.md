# Setup an OKD cluster

## Assisted local installation

- [Get the latest version of RHCOS available](https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/latest/) and [the related version](https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/latest/rhcos-id.txt)
- Update [assisted-installer.yaml](./installation/assisted-installer.yaml) accordingly

```sh
# Run the Assistant installer Pod
podman kube play assisted-installer.yaml --replace
```

Use the pull secret below if you do not plan to use a real one.

```json
{"auths":{"fake":{"auth":"aWQ6cGFzcwo="}}}
```

> It is recommended to use a working pull secret to have access to all the Operator marketplace.
