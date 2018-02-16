#!/bin/bash

OPTS=`getopt -o odkh --long os,docker,kubernetes,help -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

#echo "$OPTS"
eval set -- "$OPTS"

OS=false
DOCKER=false
KUBERNETES=false
HELP=false

if [ $# -le 1 ]; then
    echo "No arguments supplied, proceeding with full deployment"
    OS=true
    DOCKER=true
    KUBERNETES=true
fi

while true; do
  case "$1" in
    -o | --OS         )  OS=true;         shift ;;
    -d | --docker     )  DOCKER=true;     shift ;;
    -k | --kubernetes )  KUBERNETES=true; shift ;;
    -h | --help       )  HELP=true;       shift ;;
    -- ) shift; break ;;
    *  ) break ;;
  esac
done

if [ "$HELP" = true ]; then
    cat <<EOF
    When not providing an option, all options will selected by default.

    -o | --OS         : Execute the OS Preparation script
    -d | --docker     : Execute the Docker Setup script
    -k | --kubernetes : Kubernetes Worker Node Setup script
    -h | --help       : Help Message
EOF
else
    echo "You are running Latest Kubernetes version Deployment Script as WORKER"
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

        ./preps/prep-daemon.sh

        sleep 1

        ./preps/docker-setup.sh

        sleep 1
    fi

    if [ "$KUBERNETES" = true ]; then
        ./preps/k8s-setup.sh

        sleep 1
    fi
fi