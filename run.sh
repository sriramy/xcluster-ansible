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

# start test
export PATH="${PATH}:$(ovl_path ${OVL})"
cd "$(ovl_path ${OVL})"
${OVL}.sh test ${TESTCASE}

log_execution_stop
