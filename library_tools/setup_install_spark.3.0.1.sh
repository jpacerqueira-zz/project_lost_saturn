#!/usr/bin/env bash
#
cd $HOME
#
#wget https://archive.apache.org/dist/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz
wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz

mkdir -p $HOME/spark/
mv spark-3.0.1-bin-hadoop2.7.tgz $HOME/spark
cd $HOME/spark
tar -zvxf spark-3.0.1-bin-hadoop2.7.tgz
# env
echo  'export PATH="/home/notebookuser/spark/spark-3.0.1-bin-hadoop2.7/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
#
# Force pyspark for Jupyter
pip install pyspark
#
