#!/usr/bin/env bash -xe
#
#cd $HOME
DATENB=$(date +'%Y-%m-%d')
#
jupyter nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=180
$HOME/anaconda3/bin/jupyter\
          	      nbconvert --to notebook --execute --allow-errors --ExecutePreprocessor.timeout=180 \
		      $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY.ipynb  --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-output-candidate.ipynb
#
