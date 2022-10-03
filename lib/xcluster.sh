#!/bin/bash

function source_env() {
    redirect_cmd pushd .
    redirect_cmd cd "${XCLUSTER_PATH}"
    if [[ "$K8S" == "true" ]]; then
        log "Source xcluster Envsettings.k8s"
        redirect_cmd source "${XCLUSTER_PATH}/Envsettings.k8s"
    else
        log "Source xcluster Envsettings"
        redirect_cmd source "${XCLUSTER_PATH}/Envsettings"
    fi
    redirect_cmd popd
}

function __check_ns() {
    local __ns_prefix="1"
    if [ $# -ge 1 ] && [ -n "$1" ]; then
        __ns_prefix=$1
    fi
    local __netns=${USER}_xcluster$__ns_prefix
    ip netns | grep -qe "^$__netns "
}

function add_ns() {
    local __ns_prefix="1"
    if [ $# -ge 1 ] && [ -n "$1" ]; then
        __ns_prefix=$1
    fi

    if __check_ns $__ns_prefix; then
        log "Netns $__ns_prefix already exists"
    else
        log "Add netns $__ns_prefix"
        source_env
        redirect_cmd ${XCLUSTER} nsadd $__ns_prefix
    fi
}

function rem_ns() {
    local __ns_prefix="1"
    if [ $# -ge 1 ] && [ -n "$1" ]; then
        __ns_prefix=$1
    fi

    if __check_ns $__ns_prefix; then
        log "Remove netns $__ns_prefix"
        source_env
        redirect_cmd ${XCLUSTER} nsdel $__ns_prefix
    else
        log "Netns $__ns_prefix doesn't exist"
    fi
}

function exec_ns() {
    local __netns=${USER}_xcluster$1
    local __cmd=$2
    log "Run $__cmd in $__netns"
    ip netns exec $__netns $__cmd
}

function ovl_path() {
	echo $($XCLUSTER ovld $1)
}