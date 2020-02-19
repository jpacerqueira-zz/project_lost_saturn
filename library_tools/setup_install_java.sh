#!/usr/bin/env bash
#
#########sudo apt install openjdk8-installer
#sudo add-apt-repository -y ppa:webupd8team/java
#sudo apt-get update -y && apt-get install -y \
#    openjdk-8-jre-headless \
#    openjdk-8-jdk \
#    openjdk-11-jre-headless \
#    apt install openjdk-11-jdk 
#
#########sudo apt install openjdk11-installer
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update -y && apt-get install -y \
     openjdk-11-jre-headless
sudo apt-get install -y openjdk-11-jdk
sudo apt-get install -y openjdk-8-jdk openjdk-8-jre
#########sudo apt install openjdk11-installer - As Default JAVA
export JAVA_HOME=/usr/lib/jvm/default-java
#
# Install alternative Oracle Java
#mkdir -p $HOME/java
#cp /mnt/c/Users/joci/Downloads/jdk-8u221-linux-x64.tar.gz $HOME/java
#cp /mnt/c/Users/joci/Downloads/jce_policy-8.zip $HOME/java
#cp /mnt/c/Users/joci/Downloads/jdk-8u221-linux-x64.tar.gz $HOME/java

#cp /mnt/c/Users/joci/Downloads/install-java-master.zip .
#unzip install-java-master.zip
#cp $HOME/install-java-master/*.sh  $HOME/java
#chmod +x $HOME/java/*.sh 
#cp $HOME/java/*.sh $HOME
##### DOESN'T WORK ##### yes | sudo -E .$HOME/java/install_java.sh -f $HOME/java/jdk-8u221-linux-x64.tar.gz  /usr/lib/jvm
#sudo bash -x ./java/install-java.sh -f /home/joci/java/jdk-8u221-linux-x64.tar.gz /usr/lib/jvm
#
# INSTALL JAVA ORACLE KNode DockerFile
# 
# Workarround for big files broken into max. 23MB file size zip
#
if [ ! -f "${HOME}/java/jdk-8u221-linux-x64.tar.gz" ]; then
    echo "File ${HOME}/java/jdk-8u221-linux-x64.tar.gz does not exist"
    cat $HOME/java/jdk-8u221-linux-x64.tar.zip.0* > $HOME/java/jdk-8u221-linux-x64.tar.zip
    cd $HOME/java
    unzip jdk-8u221-linux-x64.tar.zip
fi
cd $HOME
## execute ORACLE JAVA Standard installation
if [ -f "${HOME}/java/jdk-8u221-linux-x64.tar.gz" ]; then
    echo 'y\ny\ny\ny\n' | sudo bash -x $HOME/java/install-java.sh -f $HOME/java/jdk-8u221-linux-x64.tar.gz /usr/lib/jvm
fi
pwd
ls /usr/lib/jvm/java-8-openjdk-amd64/
cd /usr/lib/jvm/
sudo ln -s java-8-openjdk-amd64 default-java
pwd
cd $HOME
pwd
#
