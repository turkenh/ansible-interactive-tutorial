#!/bin/bash
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NOF_HOSTS=3
NETWORK_NAME="ansible.tutorial"
WORKSPACE="${BASEDIR}/workspace"
TUTORIALS_FOLDER="${BASEDIR}/tutorials"

HOSTPORT_BASE=${HOSTPORT_BASE:-42726}
# Extra ports per host to expose. Should contain $NOF_HOSTS variables
EXTRA_PORTS=( "8080" "30000" "443" )
# Port Mapping
# +-----------+----------------+-------------------+
# | Container | Container Port |     Host Port     |
# +-----------+----------------+-------------------+
# |   host0   |       80       | $HOSTPORT_BASE    |
# +-----------+----------------+-------------------+
# |   host1   |       80       | $HOSTPORT_BASE+1  |
# +-----------+----------------+-------------------+
# |   host2   |       80       | $HOSTPORT_BASE+2  |
# +-----------+----------------+-------------------+
# |   host0   | EXTRA_PORTS[0] | $HOSTPORT_BASE+3  |
# +-----------+----------------+-------------------+
# |   host1   | EXTRA_PORTS[1] | $HOSTPORT_BASE+4  |
# +-----------+----------------+-------------------+
# |   host2   | EXTRA_PORTS[2] | $HOSTPORT_BASE+5  |
# +-----------+----------------+-------------------+

DOCKER_IMAGETAG=${DOCKER_IMAGETAG:-1.1}
DOCKER_HOST_IMAGE="turkenh/ubuntu-1604-ansible-docker-host:${DOCKER_IMAGETAG}"
TUTORIAL_IMAGE="turkenh/ansible-tutorial:${DOCKER_IMAGETAG}"

function help() {
    echo -ne "-h, --help              prints this help message
-r, --remove            remove created containers and network
-t, --test              run lesson tests
"
}
function doesNetworkExist() {
    return $(docker network inspect $1 >/dev/null 2>&1)
}

function removeNetworkIfExists() {
    doesNetworkExist $1 && echo "removing network $1" && docker network rm $1 >/dev/null
}

function doesContainerExist() {
    return $(docker inspect $1 >/dev/null 2>&1)
}

function isContainerRunning() {
    [[ "$(docker inspect -f "{{.State.Running}}" $1 2>/dev/null)" == "true" ]]
}

function killContainerIfExists() {
    doesContainerExist $1 && echo "killing/removing container $1" && { docker kill $1 >/dev/null 2>&1; docker rm $1 >/dev/null 2>&1; };
}

function runHostContainer() {
    local name=$1
    local image=$2
    local port1=$(($HOSTPORT_BASE + $3))
    local port2=$(($HOSTPORT_BASE + $3 + $NOF_HOSTS))

    echo "starting container ${name}: mapping hostport $port1 -> container port 80 && hostport $port2 -> container port ${EXTRA_PORTS[$3]}"
    if doesContainerExist ${name}; then
        docker start "${name}" > /dev/null
    else
        docker run -d -p $port1:80 -p $port2:${EXTRA_PORTS[$3]} --net ${NETWORK_NAME} --name="${name}" "${image}" >/dev/null
    fi
    if [ $? -ne 0 ]; then
        echo "Could not start host container. Exiting!"
        exit 1
    fi
}

function runTutorialContainer() {
    local entrypoint=""
    local args=""
    if [ -n "${TEST}" ]; then
        entrypoint="--entrypoint nutsh"
        args="test /tutorials ${LESSON_NAME}"
    fi
    killContainerIfExists ansible.tutorial > /dev/null
    echo "starting container ansible.tutorial"
    docker run -it -v "${WORKSPACE}":/root/workspace:Z -v "${TUTORIALS_FOLDER}":/tutorials:Z --net ${NETWORK_NAME} \
      --env HOSTPORT_BASE=$HOSTPORT_BASE \
      ${entrypoint} --name="ansible.tutorial" "${TUTORIAL_IMAGE}" ${args}
    return $?
}

function remove () {
    for ((i = 0; i < $NOF_HOSTS; i++)); do
       killContainerIfExists host$i.example.org
    done
    removeNetworkIfExists ${NETWORK_NAME}
}

function setupFiles() {
    # step-01/02
    local step_01_hosts_file="${BASEDIR}/tutorials/files/step-1-2/hosts"
    rm -f "${step_01_hosts_file}"
    for ((i = 0; i < $NOF_HOSTS; i++)); do
        #ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' host$i.example.org)
        ip=$(docker network inspect --format="{{range \$id, \$container := .Containers}}{{if eq \$container.Name \"host$i.example.org\"}}{{\$container.IPv4Address}} {{end}}{{end}}" ${NETWORK_NAME} | cut -d/ -f1)
        echo "host$i.example.org ansible_host=$ip ansible_user=root" >> "${step_01_hosts_file}"
    done
}
function init () {
    mkdir -p "${WORKSPACE}"
    doesNetworkExist "${NETWORK_NAME}" || { echo "creating network ${NETWORK_NAME}" && docker network create "${NETWORK_NAME}" >/dev/null; }
    for ((i = 0; i < $NOF_HOSTS; i++)); do
       isContainerRunning host$i.example.org || runHostContainer host$i.example.org ${DOCKER_HOST_IMAGE} $i
    done
    setupFiles
    runTutorialContainer
    exit $?
}

###
MODE="init"
TEST=""
for i in "$@"; do
case $i in
    -r|--remove)
    MODE="remove"
    shift # past argument=value
    ;;
    -t|--test)
    TEST="yes"
    shift # past argument=value
    ;;
    -h|--help)
    help
    exit 0
    shift # past argument=value
    ;;
    *)
    echo "Unknown argument ${i#*=}"
    exit 1
esac
done

if [ "${MODE}" == "remove" ]; then
    remove
elif [ "${MODE}" == "init" ]; then
    init
fi
exit 0
