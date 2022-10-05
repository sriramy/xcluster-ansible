#!/bin/bash

# set -o errexit
#set -o nounset
set -o pipefail

XCLUSTER_ANSIBLE_PATH=$(git rev-parse --show-toplevel)
export XCLUSTER_ANSIBLE_PATH

source "${XCLUSTER_ANSIBLE_PATH}/lib/vars.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/common.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/opts.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/xcluster.sh"

###############################################################################
# setup environment
###############################################################################
parse_cmdline_opts $*
log_environment
log_execution_start
bootstrap
install_distro_packages
install_ansible
start_services || true

###############################################################################
# setup network
###############################################################################
if ${XCLUSTER_CLEAN}; then
    rem_ns "${XCLUSTER_NETNS}"
fi
add_ns "${XCLUSTER_NETNS}"
log_execution_stop

###############################################################################
# Build kernel if needed
###############################################################################
exec_ns "${XCLUSTER_NETNS}" ${XCLUSTER_ANSIBLE_PATH}/kernel.sh $@

###############################################################################
# start test if $OVL is given
###############################################################################
if [[ ! -z ${OVL} ]]; then
    exec_ns "${XCLUSTER_NETNS}" ${XCLUSTER_ANSIBLE_PATH}/run.sh $@
fi
