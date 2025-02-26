#!/usr/bin/env bash

curl -Ls --request POST --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
     --header "Content-Type: application/json" \
     --data '{
             "branch": "master",
             "author_email": "cmaahs@maahsome.rocks",
             "author_name": "Christopher Maahs",
             "content": '"$(jq -Rs '.' setup-gitlab.sh)"',
             "commit_message": "create a new file"
         }' \
     "https://git.maahsome.rocks/api/v4/projects/12/repository/files/setup-gitlab%2Esh"


