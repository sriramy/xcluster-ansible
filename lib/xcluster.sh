#!/bin/bash

source_env() {
    log "Source xcluster Envsettings"
    cd "${XCLUSTER_PATH}"
    source "${XCLUSTER_PATH}/Envsettings"
}

source_env_k8s() {
    log "Source xcluster Envsettings.k8s"
    cd "${XCLUSTER_PATH}"
    source "${XCLUSTER_PATH}/Envsettings.k8s"
}

check_ns() {
    local __ns_prefix="1"
    if [ $# -ge 1 ] && [ -n "$1" ]; then
        __ns_prefix=$1
    fi
    local __netns=${USER}_xcluster$__ns_prefix
    ip netns | grep -qe "^$__netns "
}

add_ns() {
    local __ns_prefix="1"
    if [ $# -ge 1 ] && [ -n "$1" ]; then
        __ns_prefix=$1
    fi

    log "Add netns $__ns_prefix"
    ${XCLUSTER} nsadd $__ns_prefix || true
}

rem_ns() {
    local __ns_prefix="1"
    if [ $# -ge 1 ] && [ -n "$1" ]; then
        __ns_prefix=$1
    fi

    log "Remove netns $__ns_prefix"
    ${XCLUSTER} nsdel $__ns_prefix
}