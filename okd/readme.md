# Deploy OKD

## Assisted local installation

Use the pull secret below if you do not plan to use a real one

```json
{"auths":{"fake":{"auth":"aWQ6cGFzcwo="}}}
```

## Manual installation

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