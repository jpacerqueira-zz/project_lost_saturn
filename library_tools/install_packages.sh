#!/usr/bin/env bash
bash setup_install_java.sh
#
echo "baseline spark.2.4.5"
bash setup_install_spark.2.4.5.sh
#
bash install-jupyter-support-packs.sh
#
