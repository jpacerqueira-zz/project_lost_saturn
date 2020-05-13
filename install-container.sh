#!/usr/bin/env bash
#
DOCKERLS=$(docker ps | grep lost_saturn | awk -F' ' '{ print $15 }')
echo "$DOCKERLS"
HERES=$(pwd)
FILES=Setup-System-Java-Spark-h2o.ai-pyarrow.ipynb # ipynb in test to load addicional libraries
DEST_FOLDER=/home/notebookuser/notebooks/
#
if [[ $DOCKERLS != "lost_saturn" ]] && [[ -f "$HERES/notebooks/$FILES" ]]; then
#   docker run  -itd -p 9003:9003 -p 54321:54321 --cap-add=NET_ADMIN --name lost_saturn  jpacerqueira83/datascience-fullstack-vm1:latest
   docker run  -itd -p 9003:9003   --cap-add=NET_ADMIN --name lost_saturn --mount type=bind,source="$(pwd)"/notebooks,target=${DEST_FOLDER}  jpacerqueira83/datascience-fullstack-vm1:latest
   echo "  wait 12 min  - lost_saturn - full setup in progress - STEP1"
   sleep 720
   ARGS1="nbconvert --to notebook --execute --allow-errors --ExecutePreporcessor.timeout=480 notebooks/$FILES "
   docker exec -it lost_saturn /bin/bash -c "cd ; source .bashrc ; bash -x ~/anaconda3/bin/jupyter $ARGS1 "
   docker exec -it lost_saturn /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; bash -x stop-jupyter.sh ; sleep 4 ; echo 'smoke test-1' "
   docker exec -it lost_saturn /bin/bash -c "cd ; source .bashrc ; bash -x install-jupyter-support-packs.sh ;  bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; sleep infinity"
   echo "  wait 3 minutes  - lost_saturn - full setup in progress - STEP2"
   sleep 240
   echo "Setup Completed : use jupyter token above "
else
   echo "Setup not Possible! consult https://github.com/jpacerqueira"
fi
#
