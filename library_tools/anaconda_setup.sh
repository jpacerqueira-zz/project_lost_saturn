#!/usr/bin/env bash -xe
cd $HOME
mkdir anaconda3
cd anaconda3
curl -O https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
sha256sum Anaconda3-2019.03-Linux-x86_64.sh
sudo chmod +x Anaconda3-2019.03-Linux-x86_64.sh
echo 'yes' > yesinput.txt
cat yesinput.txt | bash -x Anaconda3-2019.03-Linux-x86_64.sh -b -u
cd $HOME
#conda activate base
echo  'export PATH="/home/notebookuser/anaconda3/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
$HOME/anaconda3/bin/conda create -n jupyter python=3.7 anaconda
$HOME/anaconda3/bin/activate jupyter
bash install_packages.sh
####### NOT REQUIRED  ####### bash redirect-h2o.ai.as.9004.sh
mkdir -p $HOME/library_tools
mv *.sh $HOME/library_tools
#
# conda deactivate
$HOME/anaconda3/bin/conda deactivate
