#!/usr/bin/env bash
# USING OPTION : pip install h2o-3.20.0.5
#
cd $HOME
mkdir -p $HOME/python-additional-libraries/
cd  $HOME/python-additional-libraries/

#
#
echo "wget tabulate-0.8.2 source"
wget https://files.pythonhosted.org/packages/12/c2/11d6845db5edf1295bc08b2f488cf5937806586afe42936c3f34c097ebdc/tabulate-0.8.2.tar.gz  
#        
tar -xvf tabulate-0.8.2.tar.gz  
cd tabulate-0.8.2
ls 
pwd
cd ..
pip install ./tabulate-0.8.2
#
#
echo "wget future-0.16.0  source"
wget https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz
#
tar -xvf future-0.16.0.tar.gz  
cd tabulate-0.8.2
ls 
pwd
cd ..
pip install ./future-0.16.0
#
#
#
echo "wget h2o source"
wget https://files.pythonhosted.org/packages/58/c2/be92023ecfab14f39c838e5dfe0c566519d03bc2dbedf3df27316456d2e1/h2o-3.22.0.1.tar.gz  
#
#
tar -xvf h2o-3.22.0.1.tar.gz
cd h2o-3.22.0.1
ls 
pwd
cd ..
pip install ./h2o-3.22.0.1
#
