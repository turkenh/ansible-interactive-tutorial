#!/bin/bash
NOF_HOSTS=3
NETWORK_NAME="ansible.tutorial"
DOCKER_HOST_IMAGE="turkenh/ubuntu-1604-ansible-docker-host"

function help() {
    echo -ne "-h, --help              prints this help message
-r, --remove            remove everything 
"
}
function doesNetworkExist() {
    return $(docker network inspect $1 >/dev/null 2>&1)
}

function removeNetworkIfExists() {
    doesNetworkExist $1 && echo "removing network $1" && docker network rm $1
}

function doesContainerExist() {
    return $(docker inspect $1 >/dev/null 2>&1)
}

function killContainerIfExists() {
    doesContainerExist $1 && echo "killing container $1" && docker kill $1
}

function runContainer() {
    local mode_flag=$1
    local name=$2
    local image=$3
    echo "starting container ${name}"
    docker run --rm "${mode_flag}" --net ${NETWORK_NAME} --name="${name}" "${image}"
}

function remove () {
    for ((i = 0; i < $NOF_HOSTS; i++)); do
       killContainerIfExists host$i.example.org
    done
    killContainerIfExists ansible-tutorial
    removeNetworkIfExists ${NETWORK_NAME}
} 

function init () {
    echo "creating network ${NETWORK_NAME}" && docker network create "${NETWORK_NAME}"
    for ((i = 0; i < $NOF_HOSTS; i++)); do
       runContainer -d host$i.example.org ${DOCKER_HOST_IMAGE}
    done
    runContainer -it ansible.tutorial turkenh/ansible-tutorial
}

###
MODE="init"
for i in "$@"; do
case $i in
    -r|--remove)
    MODE="remove"
    shift # past argument=value
    ;;
    -h|--help)
    help
    exit 0
    shift # past argument=value
    ;;
    *)
    echo "Unknow argument ${i#*=}"
    exit 1
esac
done

remove
if [ "${MODE}" == "init" ]; then
    init
fi
