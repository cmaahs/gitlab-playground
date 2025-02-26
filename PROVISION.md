# Provisioning

## Spin Up

```zsh
# SET THESE
AZ_TENANT="ea2fb1cd-e46b-4610-bc1a-a62f6d0835a3"

GIT_HOST=git  # git|lab
az login --tenant ${AZ_TENANT}
az aks get-versions --location northcentralus
cd terraform
# update the latest kubernetes aks version
vi environments/${GIT_HOST}.tfvars
mkdir -p state/${GIT_HOST}
terraform plan --var-file environments/${GIT_HOST}.tfvars -state=state/${GIT_HOST}/terraform.tfstate -out plan.out
terraform apply -state=state/${GIT_HOST}/terraform.tfstate plan.out

az aks get-credentials --admin --resource-group gitlab-${GIT_HOST} --name gitlab-${GIT_HOST} --overwrite-existing --file ~/.kube/config.gitlab-${GIT_HOST}

cd ../helm
# before running this, you MUST update the maahsome-rocks-tls.yaml with valid certificate data
./install-nginx.sh ${GIT_HOST}

# add IP address to maahsome.rocks DNS
IP_UPDATE=$(kubectl -n ingress-nginx get service/ingress-nginx-controller -o json | jq -r '.status.loadBalancer.ingress[] | .ip')
# hover is STUPID.  Reminder to NOT use it anymore.  You MUST logon, and disable 2Factor EMail in order to make this work
# there is NO official API for updating DNS.  Research a NEW Domain/DNS provider
cd ../hover
./update-hover-dns update --zone-name "maahsome.rocks" --record-name "${GIT_HOST}" --record-value "${IP_UPDATE}"
sleep 1
./update-hover-dns update --zone-name "maahsome.rocks" --record-name "git-kas" --record-value "${IP_UPDATE}"
sleep 1
./update-hover-dns update --zone-name "maahsome.rocks" --record-name "git-minio" --record-value "${IP_UPDATE}"
sleep 1
./update-hover-dns update --zone-name "maahsome.rocks" --record-name "git-registry" --record-value "${IP_UPDATE}"

cd ../helm
# lots of maahsome.rocks refs in the install-gitlab.sh script
./install-gitlab.sh ${GIT_HOST}
./get-gitlab-root-pw.sh ${GIT_HOST}
# -> manually logon, create access_token
# add access_token to bw
# setup gitlab
#  - Set visibility, set master branch defaults
```

## Spin Down

```zsh
terraform plan -destroy --var-file environments/${GIT_HOST}.tfvars -state=state/${GIT_HOST}/terraform.tfstate -out plan.out
terraform apply -state=state/${GIT_HOST}/terraform.tfstate plan.out
```

## Additional Resources

### set-gitlab-root-pat.sh

This is a script specific to storing a newly changed ROOT ACCESS TOKEN into bitwarden

### CREATE_RENEW_CERT

Very specific to maahsome.rocks Let's Encrypt certificate generation

### test-upload.sh

Curl command to upload directly to the repository/project

### update-dns.sh

Specific to Hover DNS updates for maahsome.rocks

### hover (directory)

Some golang code to assist with the fact that Hover has NO API to update DNS.  Slackers.

### scripts/setup-gitlab.sh

Some code that will setup some base directory structures, mostly for playing with ArgoCD
