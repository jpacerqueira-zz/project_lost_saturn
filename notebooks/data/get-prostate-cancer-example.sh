#!/usr/bin/env bash
#
rm $HOME/notebooks/data/prostate.csv
touch $HOME/notebooks/data/prostate.csv
curl https://github.com/h2oai/h2o-sparkling/blob/master/data/prostate.csv -o $HOME/notebooks/data/prostate.csv
### 
