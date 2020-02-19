#!/usr/bin/env bash
# USING OPTION : pip install kafka-1.3.5 
cd $HOME
mkdir -p $HOME/python-additional-libraries/
cd  $HOME/python-additional-libraries/
echo "wget latest from https://pypi.python.org/pypi/kafka#downloads "
wget https://pypi.python.org/packages/3b/1b/44605e699e0970a2be3d7135d185f95e8605399aa0f2a9d64de342eae4b7/kafka-1.3.5.tar.gz#md5=ccea518f48ee50a301ac4611ac8f73ee
tar -xvf kafka-1.3.5.tar.gz
cd kafka-1.3.5
ls 
pwd
cd ..
pip install ./kafka-1.3.5
#
