#!/usr/bin/env bash -xe
#
HOME=/home/notebookuser
source $HOME/.profile
cd $HOME/crontab
DATENB=$(date +'%Y-%m-%d')
#
$HOME/anaconda3/bin/jupyter \
       nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=1800 \
       $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY.ipynb  \
       --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-output-candidate.ipynb > crontab-run-$DATENB.log
#
