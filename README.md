# ansible-interactive-tutorial

[![Build Status](https://travis-ci.org/turkenh/ansible-interactive-tutorial.svg?branch=master)](https://travis-ci.org/turkenh/ansible-interactive-tutorial)

Interactive tutorials for Ansible

## Prerequisite

Only prerequisite is **docker**

Requires docker version 1.9+ and tested with 1.12+

If you don't have docker installer, you can also run on http://play-with-docker.com (just click "+ ADD NEW INSTANCE" button and clone this repo there)

## How to Run

```bash
./tutorial.sh
```

[![demo](https://asciinema.org/a/CPUhOGGlcLiXVlZKIuiuk5Q7f.png)](https://asciinema.org/a/CPUhOGGlcLiXVlZKIuiuk5Q7f?autoplay=1)

## Clean up

```bash
./tutorial.sh --remove
```

## More Details

### Tutorials

Almost all of the tutorials are adapted from the great [leucos/ansible-tuto](https://github.com/leucos/ansible-tuto) repository:

```
1. Getting Started
2. Basic inventory
3. First modules and facts
4. Groups and variables
5. Playbooks
6. Playbooks, pushing files on nodes
7. Playbooks and failures
8. Playbook conditionals
9. Git module
10. Extending to several hosts
11. Templates
12. Variables again
13. Migrating to roles!
14. Using roles from Ansible Galaxy - Install a Jenkins server
15. Free play
```

You can run each lesson individually but it is **highly encouraged to follow the order** as most of them are built on top of the previous one!


### Containers

`tutorial.sh` starts 4 docker containers behind the scenes. 1 for running the tutorial itself and 3 as ansible nodes which behave exactly same as (virtual or physical) machines throughout the tutorial. 

**ansible.tutorial** is an alpine based tutorial container in which ansible and [nutsh](https://github.com/turkenh/nutsh) (a framework for creating interactive command line tutorials) are available.

**host0.example.org**, **host1.example.org** and **host2.example.org** are the Ubuntu 16.04 based containers that act as ansible nodes. These nodes were already provisioned with the ssh key of **ansible.tutorial** container. So that you don't have to deal with setting up keys.

### Port Mapping

There are some checkpoints in the tutorials where you can check and verify your deployments. For this purpose some ports of the containers are exposed as host ports as follows:

Container|Container Port|Host Port   
:---|:---:|:---:
host0.example.org|80|`$HOSTPORT_BASE`  
host1.example.org|80|`$HOSTPORT_BASE+1`
host2.example.org|80|`$HOSTPORT_BASE+2`
host0.example.org|8080|`$HOSTPORT_BASE+3`
host1.example.org|30000|`$HOSTPORT_BASE+4`
host2.example.org|443|`$HOSTPORT_BASE+5`

`HOSTPORT_BASE` is set to `42726` by default and can be changed while starting the tutorial (in case any of the consecutive 6 ports is not available) as follows:

```bash
./tutorial.sh --remove # Make sure you shut down the previous ones
HOSTPORT_BASE=<some_other_value> ./tutorial.sh
```

### Workspace Directory
`ansible-interactive-tutorial/workspace` directory on your local machine is mounted as `/root/workspace` inside the **ansible.tutorial** container. So, you can use your favorite editor on your local machine to edit files. Editing files is not necessary to follow the lessons though.




