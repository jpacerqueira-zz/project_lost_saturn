#!/bin/bash
#
sudo rm -rf /tmp/docker-compose
sudo curl -sSL https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m`>/tmp/docker-compose &&
sudo chmod +x /tmp/docker-compose &&
sudo cp /tmp/docker-compose  /usr/local/bin/docker-compose
#
