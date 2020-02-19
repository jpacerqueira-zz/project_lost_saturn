#!/bin/bash
#
#!/bin/bash
#
docker pull tensorflow/tensorflow:nightly-py3-jupyter
IMAGE_TSFLOW=$(docker image ls | grep tensorflow | awk -F' ' '{ print $1 }')
echo ${IMAGE_TSFLOW}
#:-WSL-:#
FILE1=Setup-System-Java-Spark-h2o.ai-pyarrow.ipynb # # ipynb in test to load additional libraries
if [ -f "/mnt/c/Users/joci/Documents/GitHub/Jupyter_Spark_H2O_Kafka_Client_Setup/notebooks/$FILE1" ]; then
    docker run -it -p 9003:8888 -v c:/Users/joci/Documents/GitHub/Jupyter_Spark_H2O_Kafka_Client_Setup/notebooks:/tf/notebooks_h2o ${IMAGE_TSFLOW}:nightly-py3-jupyter jupyter nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=180 /tf/notebooks_h2o/$FILE1 
else 
    docker run -it -p 9003:8888 -v c:/Users/joci/Documents/GitHub/Jupyter_Spark_H2O_Kafka_Client_Setup/notebooks:/tf/notebooks_h2o ${IMAGE_TSFLOW}:nightly-py3-jupyter
fi
#:-VBox-:#
#if [ -f "/$FILE1"]; then
#  docker run -it -p 9003:8888 -v /Users/joaocerqueira/Documents/github/Jupyter_Spark_H2O_Kafka_Client_Setup/notebooks:/tf/notebooks_h2o ${IMAGE_TSFLOW}:nightly-py3-jupyter jupyter nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=180 /tf/notebooks_h2o/$FILE1 
#else
#  docker run -it -p 9003:8888 -v /Users/joaocerqueira/Documents/github/Jupyter_Spark_H2O_Kafka_Client_Setup/notebooks:/tf/notebooks_h2o ${IMAGE_TSFLOW}:nightly-py3-jupyter
#if
