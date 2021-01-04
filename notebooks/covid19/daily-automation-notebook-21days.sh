#!/usr/bin/env bash
#
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
export SPARK_LOCAL_IP=0.0.0.0
#
source ~/.bashrc
#
### Workarround for Delta Lake format
###
export PACKAGES="io.delta:delta-core_2.11:0.5.0"
export PYSPARK_SUBMIT_ARGS="--packages ${PACKAGES}  pyspark-shell"
###
#
#
HOME=/home/notebookuser
source $HOME/.profile
cd $HOME/crontab
DATENB=$(date +'%Y-%m-%d')
# 14DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v14.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-14dayForecast-output-candidate.ipynb > crontab-run-$DATENB.log
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred14Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred14Days-displayFuelBigData.html      
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred14Days-displayFuelBigData.html
sleep 1
#rm -rf  /tmp/*
# 21DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-output-candidate.ipynb >> crontab-run-$DATENB.log
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred21Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred21Days-displayFuelBigData.html
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred21Days-displayFuelBigData.html
sleep 1
#rm -rf  /tmp/*
# 42DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v42.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-42dayForecast-output-candidate.ipynb >> crontab-run-$DATENB.log
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred42Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred42Days-displayFuelBigData.html
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred42Days-displayFuelBigData.html
sleep 1
#rm -rf  /tmp/*
# 63DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v63.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-63dayForecast-output-candidate.ipynb >> crontab-run-$DATENB.log
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred63Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred63Days-displayFuelBigData.html
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred63Days-displayFuelBigData.html
sleep 1
#
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v1data.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-1dayForecast-data-output.ipynb >> crontab-run-$DATENB.log
#
cd $HOME/notebooks/covid19/data/
bash -x automate-daily-analysis-file.sh ${DATENB} >> crontab-run-$DATENB.log
cd $HOME
#
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/Daily-Covid19-Analysis-Spark-SQL-DeltaLake-version1.0.ipynb \
       --output $HOME/notebooks/covid19/Daily-Covid19-Analysis-Spark-SQL-DeltaLake-version1.0_${DATENB}.ipynb >> crontab-run-$DATENB.log
#
rm -rf  /tmp/*
#