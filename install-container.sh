#!/usr/bin/env bash
#
DOCKERLS=$(docker ps | grep lost_saturn | awk -F' ' '{ print $15 }')
echo "$DOCKERLS"
#
if [[ $DOCKERLS != "lost_saturn" ]]; then
#   docker run  -itd -p 9003:9003 -p 54321:54321 --cap-add=NET_ADMIN --name lost_saturn  jpacerqueira83/datascience-fullstack-vm1:latest
   docker run  -itd -p 9003:9003 --cap-add=NET_ADMIN --name lost_saturn  jpacerqueira83/datascience-fullstack-vm1:latest
   echo "  wait 12 min  - lost_saturn - full setup in progress "
   sleep 720
fi
#
HERES=$(pwd)
FILES=Setup-System-Java-Spark-h2o.ai-pyarrow.ipynb # ipynb in test to load addicional libraries
#
if [[ -f "$HERES/notebooks/$FILES" ]]; then
   ARGS1="nbconvert --to notebook --execute --allow-errors --ExecutePreporcessor.timeout=480 notebooks/$FILES "
   docker exec -it lost_saturn /bin/bash -c "cd ; source .bashrc ; bash -x ~/anaconda3/bin/jupyter $ARGS1 "
   docker exec -it lost_saturn /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; sleep infinity"
else
   docker exec -it lost_saturn /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; sleep infinity"
fi
#
