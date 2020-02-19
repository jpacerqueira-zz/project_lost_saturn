#!/bin/bash
#
sudo docker ps -aq | while read line;  do sudo docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $line ; done
