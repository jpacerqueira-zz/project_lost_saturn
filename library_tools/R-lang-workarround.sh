#!/usr/bin/env bash -xe
#
echo "install R language"
bash -x $HOME/library_tools/setup_install_R_lang.sh 
echo " Run once manually : If R + rpy2 in python/jupyter are in functional lock with R cli package :_."
bash -x $HOME/library_tools/setup_install_conda_r.sh 2
#
