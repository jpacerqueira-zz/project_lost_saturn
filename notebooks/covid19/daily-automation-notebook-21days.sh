#!/usr/bin/env bash -xe
#
#cd $HOME
DATENB=$(date +'%Y-%m-%d')
#
$HOME/anaconda3/bin/python \
                      --execute \
                      --to notebook $HOME/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY.ipynb \
                      --output $HOME/notebooks/covid19/MY_COVID19-Prediction_${DATENB}-output-candidate.ipynb
#
