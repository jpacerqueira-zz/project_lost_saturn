#!/bin/bash
#
IMAGE_NAME=gftjoao/datascience-fullstack-v1.0
docker run -it -v ~/Downloads:/Downloads $IMAGE_NAME bash
#
######
#notebookuser@c703830efb28:/$ cp  /Downloads/jdk-8u221-linux-x64.tar.gz /home/notebookuser/java/
#notebookuser@c703830efb28:/$ chown notebookuser:notebookuser /home/notebookuser/java/jdk-8u221-linux-x64.tar.gz 
#notebookuser@c703830efb28:/$ sudo su - notebookuser
#notebookuser@c703830efb28:~$ cd java/
#notebookuser@c703830efb28:~$ ls $HOME
######
###### MACHINE_NAME=quizzical_napier
###### docker-machine  scp -r ~/Downloads/jdk-8u221-linux-x64.tar.gz  notebookuser@${MACHINE_NAME}:~/java
