#!/usr/bin/env bash
bash setup_install_java.sh
#
echo "baseline spark.3.0.1"  
bash setup_install_spark.3.0.1.sh
#
bash install-jupyter-support-packs.sh
#
