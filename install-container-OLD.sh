#!/usr/bin/env bash
#
DOCKERLS=$(docker ps | grep jupyter_container | awk -F' ' '{ print $15 }')
echo "$DOCKERLS"
HERES=$(pwd)
FILES=Setup-System-Java-Spark-h2o.ai-pyarrow.ipynb # ipynb in test to load addicional libraries
DEST_FOLDER=/home/notebookuser/notebooks/
#
if [[ $DOCKERLS != "jupyter_container" ]] && [[ -f "$HERES/notebooks/$FILES" ]]; then
   echo "setup ; option1"
   docker run  -itd -p 9003:9003   --cap-add=NET_ADMIN --name jupyter_container --mount type=bind,source="$(pwd)"/notebooks,target=${DEST_FOLDER}  jpacerqueira83/jupyter_datascience:stable
   echo "  wait 1/2 min  - jupyter_container - full setup in progress - STEP1"
   sleep 30
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; bash -x stop-jupyter.sh ; sleep 4 ; echo 'setup1: smoke test' "
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x install-jupyter-support-packs.sh ; sleep 4 ; echo 'setup2 : additional libraries instalation' "
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; echo 'setup : completed - jupyter token above';  sleep infinity"
elif [[ $DOCKERLS != "jupyter_container" ]]; then
   echo "setup ; option2"
   docker run  -itd -p 9003:9003   --cap-add=NET_ADMIN --name jupyter_container jpacerqueira83/jupyter_datascience:stable
   echo "  wait 1/2 min  - jupyter_container - full setup in progress - STEP1"
   sleep 30
   ARGS1="nbconvert --to notebook --execute --allow-errors --ExecutePreporcessor.timeout=480 notebooks/$FILES "
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x ~/anaconda3/bin/jupyter $ARGS1 "
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; bash -x stop-jupyter.sh ; sleep 4 ; echo 'setup1: smoke test' "
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x install-jupyter-support-packs.sh ; sleep 4 ; echo 'setup2 : additional libraries instalation' "
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; echo 'setup : completed - jupyter token above';  sleep infinity"
else
   echo "Setup not Possible! consult https://github.com/jpacerqueira"
fi
#
