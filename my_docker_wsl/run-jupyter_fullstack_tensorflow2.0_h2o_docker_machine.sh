#!/bin/bash
#
docker pull tensorflow/tensorflow:nightly-py3-jupyter
IMAGE_TSFLOW=$(docker image ls | grep tensorflow | awk -F' ' '{ print $1 }')
echo ${IMAGE_TSFLOW}
#:-WSL-:#
#docker run -it -p 9003:8888 -v c:/Users/joci/Documents/GitHub/Jupyter_Spark_H2O_Kafka_Client_Setup/notebooks:/tf/notebooks_h2o ${IMAGE_TSFLOW}:nightly-py3-jupyter 
#:-VBox-:#
docker run -it -p 9003:8888 -v /Users/joaocerqueira/Documents/github/Jupyter_Spark_H2O_Kafka_Client_Setup/notebooks:/tf/notebooks_h2o ${IMAGE_TSFLOW}:nightly-py3-jupyter 
#
