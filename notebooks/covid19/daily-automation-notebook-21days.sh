#!/usr/bin/env bash
#
HOME=/home/notebookuser
source $HOME/.profile
cd $HOME/crontab
DATENB=$(date +'%Y-%m-%d')
# 14DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=1800 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v14.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-14dayForecast-output-candidate.ipynb > crontab-run-$DATENB.log
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred14Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred14Days-displayFuelBigData.html      
sleep 1
rm -rf  /tmp/*
# 21DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=1800 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-output-candidate.ipynb > crontab-run-$DATENB.log
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred21Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred21Days-displayFuelBigData.html
sleep 1
rm -rf  /tmp/*
# 42DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=1800 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v42.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-42dayForecast-output-candidate.ipynb > crontab-run-$DATENB.log
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred42Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred42Days-displayFuelBigData.html
sleep 1
rm -rf  /tmp/*
# 63DayForecast
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=1800 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY-v63.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-63dayForecast-output-candidate.ipynb > crontab-run-$DATENB.log
mv $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred63Days.html $HOME/notebooks/covid19/heatmaps/Heatmap_Folium-Regional-${DATENB}-pred63Days-displayFuelBigData.html
#
cp $HOME/notebooks/covid19/data/World\ v2\ --\ Confirmed\ -\ 63Day\ Forecast\ --\ train\ ${DATENB}.csv $HOME/notebooks/covid19/data/World\ v2\ --\ Confirmed\ -\ 1Day\ Forecast\ --\ train\ ${DATENB}.csv
#