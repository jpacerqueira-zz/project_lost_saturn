#!/usr/bin/env bash -xe
rm -rf  $HOME/tmpdir
mkdir $HOME/tmpdir
cd $HOME/tmpdir
curl http://127.0.0.1:54321/3/h2o-genmodel.jar > h2o-genmodel.jar
curl http://127.0.0.1:54321/3/Models.java/GBM_grid_1_AutoML_20190726_145926_model_5 > GBM_grid_1_AutoML_20190726_145926_model_5.java
echo ' (RUN AS):~$  javac -cp h2o-genmodel.jar -J-Xmx2g -J-XX:MaxPermSize=128m GBM_grid_1_AutoML_20190726_145926_model_5.java '
#
