#!/usr/bin/env bash
# USING OPTION : pip install findspark
cd $HOME
# user access active for user:userclass initiation services in hadoop
#########################################################################################
#export KRB5CCNAME=/tmp/krb5cc_$(id -u)
#########################################################################################
#kinit -kt ~/.keytabs/$(whoami).keytab $(whoami)/chpbdaxx@BDAx.COMPANY.COM -c /tmp/krb5cc_$(id -u)
#klist /tmp/krb5cc_$(id -u)

# Spark.1.6
#echo "spark.1.6"
#export SPARK_HOME=/opt/cloudera/parcels/CDH/lib/spark

# Spark.2.4.5
echo "spark.2.4.5"
export SPARK_HOME=${HOME}/spark/spark-2.4.5-bin-hadoop2.7
export HADOOP_HOME=${SPARK_HOME}
export JAVA_HOME=/usr/lib/jvm/default-java
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS=notebook
export PYSPARK_PYTHON=${HOME}/anaconda3/bin/python
#
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/build:$PYTHONPATH
export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.7-src.zip:$PYTHONPATH
# Setup IP Spark IP
MYIP=$(hostname -I | cut -d' ' -f1)
echo $MYIP
##export SPARK_LOCAL_IP=${MYIP}
export SPARK_LOCAL_IP=0.0.0.0
# echo 'export SPARK_LOCAL_IP='${SPARK_LOCAL_IP} >> ~/.bashrc
# export SPARK_LOCAL_IP=${MYIP}

# Setup http_proxy and https_proxy
# HTTP_PROXY="export https_proxy=http://${MYIP}:3128/"
# HTTPS_PROXY="export https_proxy=http://${MYIP}:3128/"
#
#echo ${HTTP_PROXY} >> ~/.bashrc
#echo ${HTTPS_PROXY} >> ~/.bashrc
#
source ~/.bashrc
#
# export PYSPARK_SUBMIT_ARGS="--master ${SPARK_LOCAL_IP} pyspark-shell"
# export PYSPARK_SUBMIT_ARGS="--master local[*] pyspark-shell"
#
### Workarround for Delta Lake format
###
export PACKAGES="io.delta:delta-core_2.11:0.5.0"
export PYSPARK_SUBMIT_ARGS="--packages ${PACKAGES}  pyspark-shell"
###
# workarround h2o for http://localhost in notebook session
# unset http_proxy
# unset https_proxy

mkdir -p ~/notebooks/
cd ~/notebooks/

rm jupyter.log nohup.out
nohup  ~/anaconda3/bin/jupyter notebook --port 9003 --no-browser --ip=${SPARK_LOCAL_IP}  2>jupyter.log &
#
