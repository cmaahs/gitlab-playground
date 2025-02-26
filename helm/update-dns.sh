#!/usr/bin/env bash

GIT_NAME=${1}
INGRESS_IP_ADDRESS=$(kubectl -n ingress-nginx get service/ingress-nginx-controller -o json | jq -r '.status.loadBalancer.ingress[0].ip'); echo ${INGRESS_IP_ADDRESS}

if [[ -n ${GIT_NAME} ]]; then
  if [[ -n ${INGRESS_IP_ADDRESS} ]]; then
    update-hover-dns update --zone-name "maahsome.rocks" --record-name "${GIT_NAME}" --record-value "${INGRESS_IP_ADDRESS}"
    sleep 2
    update-hover-dns update --zone-name "maahsome.rocks" --record-name "${GIT_NAME}-kas" --record-value "${INGRESS_IP_ADDRESS}"
    sleep 2
    update-hover-dns update --zone-name "maahsome.rocks" --record-name "${GIT_NAME}-minio" --record-value "${INGRESS_IP_ADDRESS}"
    sleep 2
    update-hover-dns update --zone-name "maahsome.rocks" --record-name "${GIT_NAME}-registry" --record-value "${INGRESS_IP_ADDRESS}"
  fi
fi

