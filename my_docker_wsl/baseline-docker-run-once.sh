#!/bin/bash
#
docker info
docker login
#docker tag python:latest  gftjoao/datascience-fullstack-v1.0:helloworld
#docker push gftjoao/datascience-fullstack-v1.0:helloworld
#
#(base) joci@UKPC000117:~/my_docker$ docker tag python:latest  gftjoao/datascience-fullstack-v1.0:helloworld
#	(base) joci@UKPC000117:~/my_docker$ docker push gftjoao/datascience-fullstack-v1.0:helloworld
#	The push refers to repository [docker.io/gftjoao/datascience-fullstack-v1.0]
#	32f5ccb72413: Mounted from library/python
#	4ec770d3b6d2: Mounted from library/python
#	339cb66b7392: Mounted from library/python
#	1e827468edbb: Mounted from library/python
#	785186534686: Mounted from library/python
#	07efd2c6be7b: Mounted from library/python
#	ceb262f1fe29: Mounted from library/python
#	14ed28258a2c: Mounted from library/python
#	d7817c0e0675: Mounted from library/python
#	ffdc1ce49b57: Skipped foreign layer
#	70bba925263c: Skipped foreign layer
#	helloworld: digest: sha256:1d8cbba3008c64d6e4351ab558a3d7cdbd004566ce9ecd50980b87312903606c size: 2824
#
docker pull gftjoao/datascience-fullstack-v1.0:latest
#
#(base) joci@UKPC000117:~/my_docker_wsl$ docker pull gftjoao/datascience-fullstack-v1.0:latest
#latest: Pulling from gftjoao/datascience-fullstack-v1.0
#22e816666fd6: Pull complete
#079b6d2a1e53: Pull complete
#11048ebae908: Pull complete
#c58094023a2e: Pull complete
#e5a78fb1ae61: Pull complete
#62fa2a42debf: Pull complete
#8d50978a0d0d: Pull complete
#0708bdfc5a20: Pull complete
#bce63b369e93: Pull complete
#4214383b5604: Pull complete
#03aa208959af: Pull complete
#4971b884c267: Pull complete
#f9bf888c50ab: Pull complete
#06def537ea04: Pull complete
#f86b0e3e18ee: Pull complete
#Digest: sha256:3addec57ed6ff055990af438755f1fc756ee60a09c8651dd22091881f582ef1b
#Status: Downloaded newer image for gftjoao/datascience-fullstack-v1.0:latest
#docker.io/gftjoao/datascience-fullstack-v1.0:latest
#(base) joci@UKPC000117:~/my_docker_wsl$
#
docker info
#
#
#(base) joci@UKPC000117:~/my_docker_wsl$ docker info
#Client:
# Debug Mode: false
#
#Server:
#  Containers: 0
#    Running: 0
#    Paused: 0
#    Stopped: 0
#  Images: 1
#  Server Version: 19.03.4
#   Storage Driver: overlay2
#     Backing Filesystem: extfs
#     Supports d_type: true
#     Native Overlay Diff: true
#  Logging Driver: json-file
#  Cgroup Driver: cgroupfs
# Plugins:
#  Volume: local
#  Network: bridge host ipvlan macvlan null overlay
#  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
# Swarm: inactive
# Runtimes: runc
# Default Runtime: runc
# Init Binary: docker-init
# ontainerd version: b34a5c8af56e510852c35414db4c1f4fa6172339
# runc version: 3e425f80a8c931f88e6d94a8c831b9d5aa481657
# init version: fec3683
#  Security Options:
#   seccomp
#    Profile: default
# Kernel Version: 4.9.184-linuxkit
# Operating System: Docker Desktop
# OSType: linux
# Architecture: x86_64
# CPUs: 2
# Total Memory: 1.934GiB
# Name: docker-desktop
# ID: M5XY:Y4KK:RWBA:3GXE:IB7O:GXHM:CYFC:GUHO:J2CY:WL6A:EAJZ:6M4I
# Docker Root Dir: /var/lib/docker
# Debug Mode: true
#  File Descriptors: 28
#  Goroutines: 42
#  System Time: 2019-10-23T15:43:17.0678324Z
#  EventsListeners: 1
# Username: gftjoao
# Registry: https://index.docker.io/v1/
# Labels:
# Experimental: false
# Insecure Registries:
#  127.0.0.0/8
# Live Restore Enabled: false
# Product License: Community Engine
#
# (base) joci@UKPC000117:~/my_docker_wsl$ vi baseline-docker-run-once.sh
#
