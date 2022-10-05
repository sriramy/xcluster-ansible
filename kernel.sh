#!/bin/bash

set -o errexit
set -o pipefail

XCLUSTER_ANSIBLE_PATH=$(git rev-parse --show-toplevel)
export XCLUSTER_ANSIBLE_PATH

source "${XCLUSTER_ANSIBLE_PATH}/lib/vars.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/common.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/opts.sh"
source "${XCLUSTER_ANSIBLE_PATH}/lib/xcluster.sh"

parse_cmdline_opts $*
log_execution_start
source_env

# start build
if [ ! -z ${KERNEL_PATCH} ]; then
    log "Building kernel ${KERNELDIR}/${__kver} with patch ${KERNEL_PATCH}"
    redirect_cmd ${XCLUSTER} kernel_build --kpatch=${KERNEL_PATCH}
elif [ ! -d ${KERNELDIR}/${__kver} ]; then
    log "Building kernel ${KERNELDIR}/${__kver}"
    redirect_cmd ${XCLUSTER} kernel_build
fi

log_execution_stop
