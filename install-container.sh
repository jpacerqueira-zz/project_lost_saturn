#!/usr/bin/env bash
#
DOCKERLS=$(docker ps | grep jupyter_container | awk -F' ' '{ print $15 }')
echo "$DOCKERLS"
#!/usr/bin/env bash
#
DOCKERLS=$(docker ps | grep jupyter_container | awk -F' ' '{ print $15 }')
echo "$DOCKERLS"
#
if [[ $DOCKERLS != "jupyter_container" ]]; then
   docker run  -itd -p 9003:9003 --cap-add=NET_ADMIN --name jupyter_container  jpacerqueira83/jupyter_datascience:latest
   echo "  wait 1 min  - jupyter_container - full installation/setup in progress "
   sleep 60
fi
#
HERES=$(pwd)
FILES=Setup-System-Java-Spark-h2o.ai-pyarrow.ipynb # ipynb in test to load addicional libraries
#
if [[ -f "$HERES/notebooks/$FILES" ]]; then
   ARGS1="nbconvert --to notebook --execute --allow-errors --ExecutePreporcessor.timeout=480 notebooks/$FILES "
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x ~/anaconda3/bin/jupyter $ARGS1 "
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; sleep infinity"
else
   docker exec -it jupyter_container /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; sleep infinity"
fi
#
