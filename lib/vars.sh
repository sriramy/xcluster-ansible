#!/bin/bash

## xcluster-ansible variables
export VERBOSE="false"
export VENV_PATH="/tmp/${USER}/xcluster/.venv"

## xcluster variables
export ARCHIVE="${HOME}/xc/archive"
export XCLUSTER_WORKSPACE="${HOME}/xc/workspace"
export XCLUSTER_PATH="${HOME}/xc/xcluster"
export K8S="true"

# kernel specific variables
export KERNELDIR="${HOME}/xc/linux"
export KERNELVER="5.19.9"

export __kver="linux-${KERNELVER}"
export __kbin="${XCLUSTER_WORKSPACE}/xcluster/bzImage-$__kver"
export __kobj="${XCLUSTER_WORKSPACE}/xcluster/obj-$__kver"
export __kcfg="${XCLUSTER_PATH}/config/$__kver"

# test specific variables
export XCLUSTER_NETNS="1"
export OVL="usrsctp"