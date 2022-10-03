#!/bin/bash

function usage() {
    # NOTE: shellcheck complains quoting in the example so SC2086 is disabled
    # shellcheck disable=SC2086
    cat <<EOF
Usage: $(basename ${0}) [-o <ovl>] [-d <run in k8s environment] [-k <kernel version] [-v] [-h]
    -o: OVL to run. (No default)
    -d: Run in k8s environment. (Default false)
    -k: Kernel version to use. (Default 5.19.9)
    -v: Run in verbose mode. (Default false)
    -h: This message.
EOF
    exit 0
}

function parse_cmdline_opts() {
    # set variables to the values set in env - otherwise, set them to defaults
    KERNELVER="${KERNELVER:-'5.19.9'}"
    OVL="${OVL:-''}"
    K8S="${K8S:-false}"
    VERBOSE="${VERBOSE:-false}"

    # get values passed as command line arguments, overriding the defaults or
    # the ones set by using env variables
    while getopts ":hk:o:dv" o; do
        case "${o}" in
        k) KERNELVER="${OPTARG}" ;;
        o) OVL="${OPTARG}" ;;
        d) K8S="true" ;;
        v) VERBOSE="true" ;;
        h) usage ;;
        *) echo "ERROR : Invalid option '-${OPTARG}'"; usage ;;
        esac
    done
    # Do all the exports
    export KERNELVER="${KERNELVER}"
    export OVL="${OVL}"
    export K8s="${K8S}"
    export VERBOSE="${VERBOSE}"
    log_summary
}

function log_summary() {
    echo
    echo "#---------------------------------------------------#"
    echo "#                    Environment                    #"
    echo "#---------------------------------------------------#"
    echo "User             : $USER"
    echo "Hostname         : $HOSTNAME"
    echo "Host OS          : $(source /etc/os-release &> /dev/null || source /usr/lib/os-release &> /dev/null; echo "${PRETTY_NAME}")"
    echo "IP               : $(hostname -I | cut -d' ' -f1)"
    echo "#---------------------------------------------------#"
    echo "#                 Execution Started                 #"
    echo "#---------------------------------------------------#"
    echo "Date & Time      : $(date -u '+%F %T UTC')"
    echo "KERNELVER        : $KERNELVER"
    echo "OVL              : $OVL"
    echo "K8S              : $K8S"
    echo "Verbose          : $VERBOSE"
    echo "#---------------------------------------------------#"
    echo
}

function log_elapsed_time() {
    elapsed_time=$SECONDS
    echo
    echo "#---------------------------------------------------#"
    echo "#                Execution Completed                #"
    echo "#---------------------------------------------------#"
    echo "Date & Time      : $(date -u '+%F %T UTC')"
    echo "Elapsed          : $((elapsed_time / 60)) minutes and $((elapsed_time % 60)) seconds"
    echo "#---------------------------------------------------#"
    echo
}
