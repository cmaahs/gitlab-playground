#!/usr/bin/env bash

GIT_HOST=${1:=git}
GIT_ROOT_PAT=${2}

# Bitwarded Specific Storage of the TOKEN
GIT_PLAYGROUND_FOLDER=$(cat ~/.config/bw/git-playground-folder)
ID=$(bw list items --folderid ${GIT_PLAYGROUND_FOLDER} | jq ".[] | select(.name==\"${GIT_HOST}-root-pat\")" | jq -r ".id"); echo ${ID}
REV_DATE=$(bw get item ${ID} | jq ".login.password = \"${GIT_ROOT_PAT}\"" | bw encode | bw edit item ${ID} | jq -r '.revisionDate'); echo ${REV_DATE}
