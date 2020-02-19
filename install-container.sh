#!/usr/bin/env bash
#
docker run  -itd -p 9003:9003 -p 54321:54321 --cap-add=NET_ADMIN --name lost_saturn  jpacerqueira83/datascience-fullstack-vm1:latest
echo "  wait 6 min "
sleep 480
docker exec -it lost_saturn /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; sleep infinity"
#
