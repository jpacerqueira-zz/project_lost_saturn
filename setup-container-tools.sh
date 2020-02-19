#!/bin/bash
#
# git clone https://github.com/jpacerqueira/Jupyter_Spark_H2O_Kafka_Client_Setup.git
#
#cd  ; cp library_tools/*.sh . ; bash -x anaconda_setup.sh
#####################################################
######### INSTALL MISSING BASIC TOOLS ###############
#sudo apt-get update
#sudo apt install curl
#sudo apt install wget
#sudo apt install zip
#sudo apt install unzip
#####################################################
#####################################################
#
cd $HOME
#
pwd
ls -laR
#
echo 'export JAVA_HOME=/usr/lib/jvm/default-java' >> $HOME/.bashrc
#
#nohup bash -x anaconda_setup.sh > $HOME/knode_ds.out 2> $HOME/knode_ds.err
bash -x anaconda_setup.sh > $HOME/knode_ds.out 2> $HOME/knode_ds.err
#
#echo 'Sleep for 4 minutes'
#sleep 241
#
#
echo 'knode_ds.out'
cat $HOME/knode_ds.out
echo 'knote_ds.err'
cat $HOME/knode_ds.err
#
sleep 1
#
cp $HOME/library_tools/start-jupyter.sh $HOME
cp $HOME/library_tools/stop-jupyter.sh $HOME
cp $HOME/library_tools/install-jupyter-support-packs.sh $HOME
echo 'export JAVA_HOME=/usr/lib/jvm/default-java' >> $HOME/.bashrc
#
# Open alternative port for Jupyter and h2o.ai in Docker image via iptable definition
sudo iptables -I INPUT 1 -p tcp --dport 54321 -j ACCEPT
sudo iptables -I INPUT 1 -p tcp --dport 9003 -j ACCEPT
#
echo "  Jupyter - SparkML - H2o.ai - Delta.io - pyArrow  "
echo "                              Installation done!   "
#
