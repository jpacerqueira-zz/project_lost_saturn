#!/usr/bin/env bash
# USING OPTION : setup-env-tools.sh 
#
bash setup_install_findspark.sh
bash setup_install_h2o.sh
bash setup_install_kafka.sh
bash setup_install_pyarrow.sh
bash setup_install_conda_r.sh 0
#
cd $HOME/library_tools/
bash setup_install_findspark.sh
bash setup_install_h2o.sh
bash setup_install_kafka.sh
bash setup_install_pyarrow.sh
bash setup_install_conda_r.sh 2 #OR# 1 # '1'-ONE :- once run if setup manually required for R + rpy2 python3
#
