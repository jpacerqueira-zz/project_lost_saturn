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
NBLOGFILE=$HOME/crontab/crontab-run-$DATENB.log
ADDRESSPUBLIC=$HOME/notebooks/covid19/my-public-address-$DATENB.txt
#
rm -rf  /tmp/*
sleep 2
#
echo "-" > $ADDRESSPUBLIC
echo "Start Date : $DATENB" >> $ADDRESSPUBLIC
echo "07DayForecast" >> $ADDRESSPUBLIC
bash -x $HOME/notebooks/covid19/my-public-address.sh >> $ADDRESSPUBLIC
#
# 07DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v07.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-07dayForecast-output-candidate.ipynb > $NBLOGFILE
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred7Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred07Days-displayFuelBigData.html      
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred07Days-displayFuelBigData.html >> $NBLOGFILE
sleep 1
rm -rf  /tmp/*
#
echo "14DayForecast" >> $ADDRESSPUBLIC
bash -x $HOME/notebooks/covid19/my-public-address.sh >> $ADDRESSPUBLIC
#
# 14DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v14.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-14dayForecast-output-candidate.ipynb >> $NBLOGFILE
cp $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-14dayForecast-output-candidate.ipynb $HOME/notebooks/covid19/MY_COVID19-Prediction.ipynb
#Ω
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred14Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred14Days-displayFuelBigData.html      
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred14Days-displayFuelBigData.html >> $NBLOGFILE
sleep 1
rm -rf  /tmp/*
#
echo "21DayForecast" >> $ADDRESSPUBLIC
bash -x $HOME/notebooks/covid19/my-public-address.sh >> $ADDRESSPUBLIC
#
# 21DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-output-candidate.ipynb >> $NBLOGFILE
#
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred21Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred21Days-displayFuelBigData.html
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred21Days-displayFuelBigData.html >> $NBLOGFILE
sleep 1
rm -rf  /tmp/*
#
echo "42DayForecast" >> $ADDRESSPUBLIC
bash -x $HOME/notebooks/covid19/my-public-address.sh >> $ADDRESSPUBLIC
#
# 42DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v42.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-42dayForecast-output-candidate.ipynb >> $NBLOGFILE
#
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred42Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred42Days-displayFuelBigData.html
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred42Days-displayFuelBigData.html >> $NBLOGFILE
sleep 1
rm -rf  /tmp/*
#
echo "63DayForecast" >> $ADDRESSPUBLIC
bash -x $HOME/notebooks/covid19/my-public-address.sh >> $ADDRESSPUBLIC
#
# 63DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v63.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-63dayForecast-output-candidate.ipynb >> $NBLOGFILE
#
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred63Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred63Days-displayFuelBigData.html
bash -x $HOME/notebooks/covid19/heatmaps/sed-format-fit-website.sh $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred63Days-displayFuelBigData.html >> $NBLOGFILE
sleep 1
rm -rf /tmp/*
#
echo "01DayForecast" >> $ADDRESSPUBLIC
bash -x $HOME/notebooks/covid19/my-public-address.sh >> $ADDRESSPUBLIC
#
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v1data.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-1dayForecast-data-output.ipynb >> $NBLOGFILE
#
sleep 1
rm -rf /tmp/*
#Ω
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v1data_drop447d.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-1dayForecast_drop447days.ipynb >> $NBLOGFILE
#
cd $HOME/notebooks/covid19/data/
bash -x automate-daily-analysis-file.sh ${DATENB} >> $NBLOGFILE
#Ω
bash -x automate-daily-analysis-file.sh ${DATENB} >> $NBLOGFILE
cd $HOME
#
echo "SparkSQLDeltaLakeCovid19DailyAnalysis" >> $ADDRESSPUBLIC
bash -x $HOME/notebooks/covid19/my-public-address.sh >> $ADDRESSPUBLIC
#
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=3600 \
       $HOME/notebooks/covid19/Daily-Covid19-Analysis-Spark-SQL-DeltaLake-DailyRun.ipynb \
       --output $HOME/notebooks/covid19/Daily-Covid19-Analysis-Spark-SQL-DeltaLake-version1.0_${DATENB}.ipynb >> $NBLOGFILE
cp $HOME/notebooks/covid19/Daily-Covid19-Analysis-Spark-SQL-DeltaLake-version1.0_${DATENB}.ipynb $HOME/notebooks/covid19/Daily-Covid19-Analysis-Spark-SQL-DeltaLake-version1.0.ipynb 
#
rm -rf  /tmp/*
#
echo "-" >> $ADDRESSPUBLIC
cat $ADDRESSPUBLIC
#
