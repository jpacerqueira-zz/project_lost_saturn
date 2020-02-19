#!/bin/bash
#
sudo rm -rf /tmp/get-docker.sh
sudo curl -sSL https://get.docker.com -o /tmp/get-docker.sh &&
sudo chmod +x /tmp/get-docker.sh &&
sh /tmp/get-docker.sh
#
