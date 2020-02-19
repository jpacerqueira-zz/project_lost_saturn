#!/usr/bin/env bash
#
# wget https://www.apache.org/dyn/closer.lua/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz
cd $HOME
#wget http://apache.mirror.anlx.net/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz
wget http://apache.mirror.anlx.net/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz
mkdir -p $HOME/spark/
mv spark-2.4.5-bin-hadoop2.7.tgz $HOME/spark
cd $HOME/spark
tar -zvxf spark-2.4.5-bin-hadoop2.7.tgz
# env
echo  'export PATH="/home/notebookuser/spark/spark-2.4.5-bin-hadoop2.7/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
#
# Force pyspark for Jupyter
pip install pyspark
#
