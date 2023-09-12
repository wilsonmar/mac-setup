#!/bin/bash

export NS="vault"  # -NS = NameSpace

# These values assume that you installed a Dev Vault cluster in the $NS namespace with Helm
#   $ helm install vault --set server.dev.enabled=true hashicorp/vault
# export VAULT_TOKEN=root
export VAULT_TOKEN=$(kubectl get secret vault-init-log -n $NS -o jsonpath={.data.root_token} | base64 -d)
# export VAULT_ADDR="http://vault.$NS.svc.cluster.local:8200"
export VAULT_ADDR="http://$(kubectl get svc vault-ui -n $NS -o jsonpath={.status.loadBalancer.ingress[].ip}):8200"
export VAULT_NAMESPACE="root"

echo $VAULT_ADDR
echo $VAULT_TOKEN


# # Creating a root token for demo purposes
# vault token create -period="0" -id="root" -policy="root" -orphan

if [ "$(helm get values -n $NS vault -o json | jq -r '.server.dev.enabled')" == "true" ];then
  echo -e "Using a Development root token"
else
  kubectl exec -i vault-0 -n $NS -- sh -c "echo ${VAULT_TOKEN} > ~/.vault-token"
fi

echo -e "Let's create a policy for reading secrets from applications... \n"
kubectl exec -i vault-0 -n $NS -- vault policy write apps - <<EOF
path "kv/hashicups-db" {
  capabilities = ["read", "update"]
}
path "kv/data/hashicups-db" {
  capabilities = ["read", "update"]
}
path "database/creds/hashicups-db" {
  capabilities = ["read"]
}
path "transit/*" {
  capabilities = ["read", "update"]
}
path "transform/*" {
  capabilities = ["read", "update"]
}
EOF

echo -e "Let's create a policy for reading secrets from Waypoint... \n"
kubectl exec -i vault-0 -n $NS -- vault policy write waypoint - <<EOF
path "kv/data/hashicups-db" {
  capabilities = ["read", "update", "list"]
}
EOF


kubectl exec -ti vault-0 -n $NS -- vault policy read apps

echo -e "\n---\n"

echo -e "Enabling Transit engine to encrypt data for Payments application \n"
kubectl exec -ti vault-0 -n $NS -- vault secrets enable transit
kubectl exec -ti vault-0 -n $NS -- vault write -f transit/keys/payments

echo -e "\n---\n"

echo -e "Storing the static secrets in Vault for our application Postgres database \n"
kubectl exec -ti vault-0 -n $NS -- vault secrets enable -version=2 kv
kubectl exec -ti vault-0 -n $NS -- vault kv put kv/db username=postgres password=password
kubectl exec -ti vault-0 -n $NS -- vault kv put kv/hashicups-db username=postgres password=password

echo -e "\n---\n"

echo -e "Configuring the Postgres Dynamic Engine \n"
kubectl exec -ti vault-0 -n $NS -- vault secrets enable database
kubectl exec -ti vault-0 -n $NS -- vault write database/config/my-postgresql-database \
  plugin_name=postgresql-database-plugin \
  allowed_roles="hashicups-db" \
  connection_url="postgresql://{{username}}:{{password}}@consul-ingress-gateway.consul:5432/products?sslmode=disable" \
  verify_connection="false" \
  username="postgres" \
  password="password"

echo -e "\n---\n"

echo -e "Configuring the Postgres role \n"
kubectl exec -ti vault-0 -n $NS -- vault write database/roles/hashicups-db \
  db_name=my-postgresql-database \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
      GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA public TO \"{{name}}\"; \
      GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="1h" \
  max_ttl="24h"
echo -e "\n---\n"

echo -e "Let's enable the Kubernetes auth method in Vault... \n "
kubectl exec -ti vault-0 -n $NS -- vault auth enable kubernetes

K8S_HOST="$(kubectl exec -ti vault-0 -n $NS -- printenv KUBERNETES_PORT_443_TCP_ADDR | tr -d '\r')"
K8S_PORT="$(kubectl exec -ti vault-0 -n $NS -- printenv KUBERNETES_PORT_443_TCP_PORT | tr -d '\r')"
VAULT_SA_SECRET="$(kubectl get sa -l app.kubernetes.io/name=vault -n $NS -o jsonpath={.items[0].secrets[0].name})"
VAULT_SA_TOKEN="$(kubectl get secret "$VAULT_SA_SECRET" -n vault -o jsonpath={.data.token} | base64 -d)"
# VAULT_SA_TOKEN="$(kubectl exec -ti vault-0 -n $NS -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
# K8S_CA="$(kubectl exec -ti vault-0 -n $NS -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt | awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}')"
kubectl exec -ti vault-0 -n $NS -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > /tmp/vault

kubectl exec -ti vault-0 -n $NS -- vault write auth/kubernetes/config \
kubernetes_host="https://$K8S_HOST:$K8S_PORT" \
issuer="" \
kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
token_reviewer_jwt="$VAULT_SA_TOKEN"
# token_reviewer_jwt=@/var/run/secrets/kubernetes.io/serviceaccount/token

echo -e "\n---\n"

echo -e "Checking Kubernetes auth config... \n "

kubectl exec -ti vault-0 -n $NS -- vault read auth/kubernetes/config

echo -e "Configuring K8s role for hashicups applications... \n "

kubectl exec -ti vault-0 -n $NS -- vault write auth/kubernetes/role/hashicups \
bound_service_account_names="postgres","payments","frontend","product-api","public-api","redis" \
bound_service_account_namespaces="apps" \
policies="apps"
ttl="1h"

echo -e "\n---\n"

echo -e "Let's check the K8s Vault authentication... \n "
echo "    \$ vault read auth/kubernetes/role/hashicups"
echo -e "\n\n"
kubectl exec -ti vault-0 -n $NS -- vault read auth/kubernetes/role/hashicups

echo -e "Configuring K8s role for Waypoint... \n "

kubectl exec -ti vault-0 -n $NS -- vault write auth/kubernetes/role/waypoint \
bound_service_account_names="waypoint","waypoint-runner","waypoint-runner-odr","product-api","payments","postgres","frontend","public-api","redis" \
bound_service_account_namespaces="waypoint","default","apps" \
policies="waypoint"
ttl="1h"

echo -e "\n---\n"

echo -e "Let's check the K8s Vault authentication... \n "
echo "    \$ vault read auth/kubernetes/role/waypoint"
echo -e "\n\n"
kubectl exec -ti vault-0 -n $NS -- vault read auth/kubernetes/role/waypoint


echo -e "\n---\n"

# We set "VAULT_ENT" env variable in the Makefile to configure Enterprise encryption features.
if [ "$VAULT_ENT" == "enabled" ];then
  echo -e "Let's configure Vault Enterprise Transform encyption... \n "
  echo -e "\n\n"
  kubectl exec -ti vault-0 -n $NS -- vault secrets enable transform

  # Setting the transform role (used by payments service if configured)
  kubectl exec -ti vault-0 -n $NS -- vault write transform/role/payments transformations=card-number
    type=fpe \
    template="builtin/creditcardnumber" \
    tweak_source=internal \
    allowed_roles=payments

  # Creating the transformation for the card-number that is using the previour role created
  kubectl exec -ti vault-0 -n $NS -- vault write transform/transformations/fpe/card-number \
    template="builtin/creditcardnumber" \     
    tweak_source=internal \     
    allowed_roles=payments

  # Following configurations are for masking the numbers, but this is not used by the application
  kubectl exec -ti vault-0 -n $NS -- vault write transform/template/masked-all-last4-card-number type=regex \
    pattern='(\d{4})-(\d{4})-(\d{4})-\d\d\d\d' \
    alphabet=builtin/numeric

  kubectl exec -ti vault-0 -n $NS -- vault write transform/transformation/masked-card-number \
    type=masking \
    template=masked-all-last4-card-number \
    tweak_source=internal \
    allowed_roles=custsupport \
    masking_character="X"

  kubectl exec -ti vault-0 -n $NS -- vault write transform/role/custsupport \
    transformations=masked-card-number
fi


# After SSH into a Vault server:
# tail -f /var/log/tf-user-data.log
   # When you see a message like the following one, the setup is complete:
   # 20##/12/11 22:05:38 /var/lib/cloud/instance/scripts/part-001: Complete
   # Exit tail command.
# vault status
# The Vault server's configuration is in /etc/vault.d/vault.hcl
# It uses the Filesystem storage backend and is listening on port 8200. 