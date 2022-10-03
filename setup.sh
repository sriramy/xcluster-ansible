#!/bin/bash

set -o errexit
#set -o nounset
set -o pipefail

XCLUSTER_ANSIBLE_PATH=$(git rev-parse --show-toplevel)
export XCLUSTER_ANSIBLE_PATH

source "${XCLUSTER_ANSIBLE_PATH}/lib/vars.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/common.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/opts.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/xcluster.sh"

# setup environment
parse_cmdline_opts $*
bootstrap
install_distro_packages
install_ansible
start_services || true

# setup network
add_ns "${XCLUSTER_NETNS}"
log_elapsed_time
