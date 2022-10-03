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
if [[ ${XCLUSTER_CLEAN} ]] && [[ -d ${KERNELDIR}/${__kver} ]]; then
    log "Removing kernel ${KERNELDIR}/${__kver}"
    rm -rf ${KERNELDIR}/${__kver}
fi

if [[ ! -z ${KERNELPATCH} ]]; then
    log "Building kernel ${KERNELDIR}/${__kver} with patch ${KERNELPATCH}"
    redirect_cmd ${XCLUSTER} kernel_build --kpatch=${KERNELPATCH}
elif [[ ! -d ${KERNELDIR}/${__kver} ]]; then
    log "Building kernel ${KERNELDIR}/${__kver}"
    redirect_cmd ${XCLUSTER} kernel_build
fi

log_execution_stop
