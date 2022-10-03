#!/bin/bash

set -o errexit
set -o pipefail

XCLUSTER_ANSIBLE_PATH=$(git rev-parse --show-toplevel)
export XCLUSTER_ANSIBLE_PATH

source "${XCLUSTER_ANSIBLE_PATH}/lib/vars.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/common.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/xcluster.sh"

bootstrap
install_distro_packages
install_ansible

if [[ "$K8S" == "true" ]]; then
    source_env_k8s
else
    source_env
fi

if check_ns "${XCLUSTER_NETNS}"; then
    log "Netns already exists"
else
    add_ns "${XCLUSTER_NETNS}"
fi