#!/bin/bash
#
export IMG_LATEST=gftjoao/datascience-fullstack-v1.0:latest
docker pull $IMG_LATEST
docker image ls
docker run -it  -p 9003:9003 --cap-add=NET_ADMIN $IMG_LATEST
#
###### MOUNT VOLUME ### 
## docker run -it -v ~/Downloads:/Downloads $IMG_LATEST bash
## sudo su - notebookuser
###### RUN MANUAL setup-env-tools.sh ## 
##### AFTER ADDTIONAL PACKAGES CP ##
## export HOME=/home/notebookuser ; cd $HOME ; bash -x $HOME/setup-env-tools.sh ; sleep 720 ; sudo chown notebookuser:notebookuser -R /home/notebookuser ; sudo cp /home/notebookuser/library_tools/start-jupyter.sh $HOME ; sudo cp /home/notebookuser/library_tools/stop-jupyter.sh $HOME ; sudo cp /home/notebookuser/library_tools/stop-jupyter.sh $HOME ; bash -x /home/notebookuser/library_tools/install-pyarrow.sh ; bash -x $HOME/start-jupyter.sh ; sleep infinity 10 ; exit  
#
#
## docker exec -it  $(docker ps -a | grep $IMG_LATEST |  awk -F' ' '{ print $1 }') /bin/bash 
#
##
#### export MY_RUNNING_CONTAINER=$(docker ps -a | grep $IMG_LATEST |  awk -F' ' '{ print $1 }' )
##
## docker inspect $MY_RUNNING_CONTAINER 
##
### docker stop $MY_RUNNING_CONTAINER
##
##### MOUNT VOLUME LATEST RUN ### docker run -it -v ~/Downloads:/Downloads $MY_RUNNING_CONTAINER bash
#### 
#### MOUNT VOLUME WHILE RUNNING LATEST RUN 
##
## follow https://medium.com/kokster/mount-volumes-into-a-running-container-65a967bee3b5 
##
## docker run $IMG_LATEST
## docker ps | grep $IMG_LATEST
##
### df ~/Downloads
## 
#### $ docker ps | grep $IMG_LATEST | awk -F' ' '{ print $1 }'
#### c8df26c4f0cc
#### $ docker inspect --format {{.State.Pid}} $( docker ps | grep $IMG_LATEST | awk -F' ' '{ print $1 }' )
#### 70141
#### $ nsenter --target 70141 4417 --mount --uts --ipc --net --pid -- mount /dev/disk1s1 /tmpmounthost
#### -bash: nsenter: command not found  
##
## https://github.com/justincormack/nsenter1
#### docker run -it --rm --privileged --pid=host justincormack/nsenter1
##
## INSIDE CONTAINER
#### ls /tmpmounthost
#
#####################################3
# DOCKER-MACHINE
#####################################3
#
# Joaos-MacBook-Pro:Jupyter_Spark_H2O_Kafka_Client_Setup joaocerqueira$ docker-machine create --driver virtualbox default
# Running pre-create checks...
# #Creating machine...
# (default) Copying /Users/joaocerqueira/.docker/machine/cache/boot2docker.iso to /Users/joaocerqueira/.docker/machine/machines/default/boot2docker.iso...
# (default) Creating VirtualBox VM...
# (default) Creating SSH key...
# (default) Starting the VM...
# (default) Check network to re-create if needed...
# (default) Waiting for an IP...
# Waiting for machine to be running, this may take a few minutes...
# Detecting operating system of created instance...
# Waiting for SSH to be available...
# Detecting the provisioner...
# Provisioning with boot2docker...
# Copying certs to the local machine directory...
# Copying certs to the remote machine...
# Setting Docker configuration on the remote daemon...
# Checking connection to Docker...
# Docker is up and running!
# To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env default
# Joaos-MacBook-Pro:Jupyter_Spark_H2O_Kafka_Client_Setup joaocerqueira$ eval $(docker-machine env default)
#
# Joaos-MacBook-Pro:Jupyter_Spark_H2O_Kafka_Client_Setup joaocerqueira$ 
# Joaos-MacBook-Pro:Jupyter_Spark_H2O_Kafka_Client_Setup joaocerqueira$ docker-machine env default
# export DOCKER_TLS_VERIFY="1"
# export DOCKER_HOST="tcp://192.168.99.101:2376"
# export DOCKER_CERT_PATH="/Users/joaocerqueira/.docker/machine/machines/default"
# export DOCKER_MACHINE_NAME="default"
# # Run this command to configure your shell: 
# # eval $(docker-machine env default)
# Joaos-MacBook-Pro:Jupyter_Spark_H2O_Kafka_Client_Setup joaocerqueira$ eval $(docker-machine env default)
#
# Joaos-MacBook-Pro:Jupyter_Spark_H2O_Kafka_Client_Setup joaocerqueira$ 
# Joaos-MacBook-Pro:Jupyter_Spark_H2O_Kafka_Client_Setup joaocerqueira$ docker-machine ls
# NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER     ERRORS
# default   -        virtualbox   Running   tcp://192.168.99.101:2376           v19.03.4   
# Joaos-MacBook-Pro:Jupyter_Spark_H2O_Kafka_Client_Setup joaocerqueira$ 
