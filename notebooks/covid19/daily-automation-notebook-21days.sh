#!/usr/bin/env bash -xe
cd $HOME
DATENB=$(date +'%Y-%m-%d')
anaconda3/bin/python \
                      --execute \
                      --to notebook notebooks/covid19/MY_COVID19-Prediction_00MMYYYY.ipynb \
                      --output notebooks/covid19/MY_COVID19-Prediction_${DATENB}-output-candidate.ipynb
#
