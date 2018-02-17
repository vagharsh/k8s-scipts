#!/bin/bash

OPTS=`getopt -o odkih --long os,docker,kubernetes,init,help -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

#echo "$OPTS"
eval set -- "$OPTS"

OS=false
DOCKER=false
KUBERNETES=false
INIT=false
HELP=false

if [ $# -le 1 ]; then
    echo "No arguments supplied, proceeding with full deployment"
    OS=true
    DOCKER=true
    KUBERNETES=true
    INIT=true
fi

while true; do
  case "$1" in
    -o | --OS         )  OS=true;         shift ;;
    -d | --docker     )  DOCKER=true;     shift ;;
    -k | --kubernetes )  KUBERNETES=true; shift ;;
    -i | --init       )  INIT=true;       shift ;;
    -h | --help       )  HELP=true;       shift ;;
    -- ) shift; break ;;
  esac
done

if [ "$HELP" = true ]; then
    cat <<EOF
    When not providing an option, all options will selected by default.

    -o | --OS         : Execute the OS Preparation script
    -d | --docker     : Execute the Docker Setup script
    -k | --kubernetes : Kubernetes Master Node Setup script
    -i | --init       : Execute the Kubernetes Master node Initialization script
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
        ./preps/k8s-setup.sh

        sleep 1
    fi

    if [ "$INIT" = true ]; then
        ./preps/k8s-init.sh

        sleep 1

        ./preps/post-init.sh

        sleep 1
    fi
fi