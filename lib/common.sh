#!/bin/bash

function redirect_cmd() {
  if [[ "$VERBOSE" == "false" ]]; then
    "$@" > /dev/null 2>&1
  else
    "$@"
  fi
}

function log() {
    __level="INFO"
    __msg="$1"

    if [ $# -ge 2 ] && [ -n "$2" ]; then
        __level="$1"
        __msg="$2"
    fi

    echo "$__level:  $__msg"
}

function bootstrap() {
    shopt -s expand_aliases
}

function install_distro_packages() {
    INSTALLER_CMD="sudo -H -E apt install -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confnew"
    PACKAGES=(
        python3-minimal
        virtualenv
    )

    log "Install distro packages"
    redirect_cmd ${INSTALLER_CMD} ${PACKAGES[@]}
}

function install_ansible() {
    log "Create virtual environment for python packages"
    redirect_cmd virtualenv --python python3 ${VENV_PATH}
    redirect_cmd source "${VENV_PATH}/bin/activate"

    log "Install ansible"
    redirect_cmd pip install ansible
}

function start_services() {
    sudo service screen-cleanup start
    sudo service docker start
}