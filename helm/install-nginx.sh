#!/usr/bin/env bash

GIT_NAME=${1}
helm upgrade --install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --set tcp.22="${GIT_NAME}/${GIT_NAME}-gitlab-shell:22" \
    --namespace ingress-nginx --create-namespace

