# Configure VAULT

## GET K8S information

```sh {"interpreter":"/bin/bash"}
# Get SNO Info
cat <<EOF > .creds.sno_info.json
{
  "host": "$(oc config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.server}')",
  "ca_pem": "$(oc config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}')",
  "token_reviewer": "$(oc get secret -n openshift-config vault-auth -o jsonpath='{.data.token}')"
}
EOF
```
