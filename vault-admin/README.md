# Configure VAULT

## GET K8S information

```sh {"interpreter":"/bin/bash"}
# Get SNO CA PEM content
oc config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.server}' > ./.data.sno.host
oc config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode > ./.data.sno_ca.pem
oc get secret -n openshift-config vault-auth -o go-template='{{ .data.token }}' | base64 --decode > ./.creds.token_reviewer.jwt
```