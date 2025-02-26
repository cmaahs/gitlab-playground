#!/usr/bin/env bash

# install ingress-nginx first
# https://docs.gitlab.com/charts/quickstart/index.html
GIT_NAME=${1}

# helm repo add gitlab https://charts.gitlab.io
# helm repo update
kubectl create namespace ${GIT_NAME}
kubectl -n ${GIT_NAME} create -f maahsome-rocks-tls.yaml

helm upgrade --install ${GIT_NAME} gitlab/gitlab \
    --set global.ingress.configureCertmanager=false \
    --set global.hosts.domain=maahsome.rocks \
    --set gitlab.webservice.ingress.tls.secretName=maahsome-rocks-tls \
    --set global.ingress.tls.secretName=maahsome-rocks-tls \
    --set nginx-ingress.enabled=false \
    --set global.ingress.class=nginx \
    --set global.hosts.gitlab.name=${GIT_NAME}.maahsome.rocks \
    --set tcp.22="${GIT_NAME}/${GIT_NAME}-gitlab-shell:22" \
    --namespace ${GIT_NAME} --create-namespace 

