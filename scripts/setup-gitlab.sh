#!/usr/bin/env bash

# SET THESE THINGS
GITLAB_DOMAIN="gitlab.maahsome.rocks"
GITLAB_EMAIL="cmaahs@gmail.com"
GITLAB_USERNAME="cmaahs"
GITLAB_NAME="Christopher Maahs"
GITLAB_PASSWORD="monkey123"
GITLAB_TOP_LEVEL_GROUP="maahsome"        # best to keep this to a single word
SSH_KEY=$(cat ~/.ssh/id_rsa_cmaahs.pub)

if [[ -z ${GITLAB_TOKEN} ]]; then
    echo "Please set GITLAB_TOKEN to a valid PAT for Gitlab"
    exit 1
fi

# create user
GITLAB_USER_ID=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{\"email\": \"${GITLAB_EMAIL}\", \"name\": \"${GITLAB_NAME}\", \"username\": \"${GITLAB_USERNAME}\", \"password\": \"${GITLAB_PASSWORD}\", \"skip_confirmation\": \"true\" }" \
         "https://${GITLAB_DOMAIN}/api/v4/users" | jq -r '.id'); echo ${GITLAB_USER_ID}

# create user PAT: cmaahs
GITLAB_USER_TOKEN=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{
                 \"name\": \"cmaahs-rt-pat\",
                 \"scopes\": [
                    \"api\",
                    \"read_user\",
                    \"read_api\",
                    \"read_repository\",
                    \"write_repository\",
                    \"read_registry\",
                    \"write_registry\"
                 ]
             }" "https://{GITLAB_DOMAIN}/api/v4/users/${GITLAB_USER_ID}/personal_access_tokens" | jq -r '.token'); echo ${GITLAB_USER_TOKEN}

echo "GITLAB_USER_TOKEN=${GITLAB_USER_TOKEN}"

# Bitwarden Specific Storage of the TOKEN
# BW_ID=$(bw get item "gitlab-argocd-user-pat" | jq -r '.id'); echo ${BW_ID}
# REV_DATE=$(bw get item ${BW_ID} | jq ".login.password = \"${GITLAB_USER_TOKEN}\"" | bw encode | bw edit item ${BW_ID} | jq -r '.revisionDate'); echo ${REV_DATE}

# add ssh key to :cmaahs
KEY_TITLE=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_USER_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{\"title\": \"cmaahs-ssh-key\", \"key\": \"${SSH_KEY}\" }" \
         "https://{GITLAB_DOMAIN}/api/v4/user/keys" | jq -r '.title'); echo ${KEY_TITLE}

# create TOP LEVEL group
GITLAB_TOP_GROUP_ID=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_USER_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{\"path\": \"${GITLAB_TOP_LEVEL_GROUP}\", "name": \"${GITLAB_TOP_LEVEL_GROUP}\" }" \
         "https://{GITLAB_DOMAIN}/api/v4/groups/" | jq -r '.id'); echo ${GITLAB_TOP_GROUP_ID}

# create top level group/helm group
HELM_ID=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_USER_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{\"path\": \"helm\", \"name\": \"helm\", \"parent_id\": \"${GITLAB_TOP_GROUP_ID}\" }" \
         "https://{GITLAB_DOMAIN}/api/v4/groups/" | jq -r '.id'); echo ${HELM_ID}

# create top level group/helm/argocd project
HELM_ARGOCD_ID=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_USER_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{
                 \"path\": \"argocd\",
                 \"default_branch\": \"main\",
                 \"initialize_with_readme\": \"true\",
                 \"visibility\": \"internal\",
                 \"namespace_id\": \"${HELM_ID}\"
             }" "https://{GITLAB_DOMAIN}/api/v4/projects" | jq -r '.id'); echo ${HELM_ARGOCD_ID}

# create top level group/deployments group
DEPLOYMENTS_ID=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_USER_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{\"path\": \"deployments\", \"name\": \"deployments\", \"parent_id\": \"${GITLAB_TOP_GROUP_ID}\" }" \
         "https://{GITLAB_DOMAIN}/api/v4/groups/" | jq -r '.id'); echo ${DEPLOYMENTS_ID}

# create top level group/deployments/<top level group}-applications
DEPLOYMENTS_APPS_ID=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_USER_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{\"path\": \"${GITLAB_TOP_LEVEL_GROUP}-applications\", \"name\": \"${GITLAB_TOP_LEVEL_GROUP}-applications\", \"parent_id\": \"${DEPLOYMENTS_ID}\" }" \
         "https://{GITLAB_DOMAIN}/api/v4/groups/" | jq -r '.id'); echo ${DEPLOYMENTS_APPS_ID}

# create maahsome/deployments/maahsome-applications/{environment/ring} project
DEPLOYMENTS_APPS_RING_ID=$(curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_USER_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "{
                 \"path\": \"dev\",
                 \"default_branch\": \"main\",
                 \"initialize_with_readme\": \"true\",
                 \"visibility\": \"internal\",
                 \"namespace_id\": \"${DEPLOYMENTS_APPS_ID}\"
             }" "https://{GITLAB_DOMAIN}/api/v4/projects" | jq -r '.id'); echo ${DEPLOYMENTS_APPS_RING_ID}
