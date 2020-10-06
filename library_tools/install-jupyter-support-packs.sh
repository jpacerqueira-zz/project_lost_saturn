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
bash setup_install_conda_r.sh 1
#
