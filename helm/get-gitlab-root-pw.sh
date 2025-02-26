#!/usr/bin/env bash

GIT_HOST=${1:=git}

GIT_ROOT_PW=$(kubectl -n ${GIT_HOST} get secret ${GIT_HOST}-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode); echo ${GIT_ROOT_PW}
echo "GIT_ROOT_PW=${GIT_ROOT_PW}"

# Bitwarden Specific Storage of the TOKEN
# GIT_PLAYGROUND_FOLDER=$(cat ~/.config/bw/git-playground-folder)
# ID=$(bw list items --folderid ${GIT_PLAYGROUND_FOLDER} | jq ".[] | select(.name==\"${GIT_HOST}-root-user\")" | jq -r ".id"); echo ${ID}
# REV_DATE=$(bw get item ${ID} | jq ".login.password = \"${GIT_ROOT_PW}\"" | bw encode | bw edit item ${ID} | jq -r '.revisionDate'); echo ${REV_DATE}
