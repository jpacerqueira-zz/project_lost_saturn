#!/bin/bash
#
sudo apt-get install linux-headers-4.15.0-66-generic ; \
sudo dpkg-reconfigure virtualbox-dkms ; sudo dpkg-reconfigure virtualbox ; \
sudo dpkg-reconfigure virtualbox-ext-pack ; sudo modprobe vboxdrv ; sudo modprobe vboxnetflt
#
# 6.) Reinstall all ; virtualbox packages
#
sudo apt-get install --reinstall virtualbox ; \
sudo apt-get install --reinstall virtualbox-qt ; \
sudo apt-get install --reinstall virtualbox-dkms ; \
sudo apt-get install --reinstall virtualbox-ext-pack ; \
sudo apt-get install --reinstall virtualbox-dkms
#
