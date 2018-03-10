#!/bin/bash

OPTS=`getopt -o odkiph --long os,docker,kubernetes,init,post,help -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

#echo "$OPTS"
eval set -- "$OPTS"

OS=false
DOCKER=false
KUBERNETES=false
INIT=false
POST=false
HELP=false

if [ $# -le 1 ]; then
    echo "No arguments supplied, proceeding with full deployment"
    OS=true
    DOCKER=true
    KUBERNETES=true
    INIT=true
    POST=true
fi

while true; do
  case "$1" in
    -o | --os         )  OS=true;         shift ;;
    -d | --docker     )  DOCKER=true;     shift ;;
    -k | --kubernetes )  KUBERNETES=true; shift ;;
    -i | --init       )  INIT=true;       shift ;;
    -p | --post       )  POST=true;       shift ;;
    -h | --help       )  HELP=true;       shift ;;
    -- ) shift; break ;;
  esac
done

if [ "$HELP" = true ]; then
    cat <<EOF
    When not providing an option, (o,d,k,i,p) options will selected by default.

    -o | --os         : Execute OS Preparation script
    -d | --docker     : Execute Docker Setup script
    -k | --kubernetes : Execute Kubernetes Master Node Setup script
    -i | --init       : Execute Kubernetes Master node Initialization script
    -p | --post       : Execute Post Initialization script
    -h | --help       : Help Message

EOF
else
    echo "You are running Latest Kubernetes version Deployment Script as MASTER"
    echo ""

    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        read -rsp $'Press any key to Exit...\n' -n1 key
        exit
    else
        echo "Running as root"
    fi
    echo ""

    if [ "$OS" = true ]; then
        ./preps/prep-os.sh
        sleep 1
    fi

    if [ "$DOCKER" = true ]; then
        ./preps/prep-disks.sh
        sleep 1

        ./preps/docker-setup.sh
        sleep 1
    fi

    if [ "$KUBERNETES" = true ]; then
        ./preps/gen-certs.sh
        sleep 1
        
        ./preps/k8s-setup.sh
        sleep 1
    fi

    if [ "$INIT" = true ]; then
        ./preps/k8s-init.sh
        sleep 1
    fi

    if [ "$POST" = true ]; then
        ./preps/post-init.sh
        sleep 1
    fi
fi