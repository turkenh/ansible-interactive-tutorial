#!/bin/bash
NOF_HOSTS=3

docker network inspect ansible.tutorial >/dev/null 2>&1 || docker network create ansible.tutorial

for ((i = 0; i < $NOF_HOSTS; i++)); do
   docker inspect host$i.example.org >/dev/null 2>&1 && docker kill host$i.example.org
   docker run --rm -d --net ansible.tutorial --name=host$i.example.org turkenh/ubuntu-1604-ansible-docker-host
done

docker inspect ansible-tutorial >/dev/null 2>&1 && docker kill ansible-tutorial
docker run -it --rm --name ansible-tutorial --net ansible.tutorial turkenh/ansible-tutorial