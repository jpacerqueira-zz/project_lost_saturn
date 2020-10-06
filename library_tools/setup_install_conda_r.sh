#!/usr/bin/env bash
# Install R default before libraries
####
OPT_DOCKER_RUN_OUT=$1
if [[ $OPT_DOCKER_RUN_OUT == 1 ]]; then
   conda install --quiet --yes \
      'r-base=3.6.1' \
      'r-rodbc=1.3*' \
      'unixodbc=2.3.*' \
      'r-irkernel=0.8*' \
      'r-plyr=1.8*' \
      'r-devtools=2.0*' \
      'r-tidyverse=1.2*' \
      'r-shiny=1.3*' \
      'r-rmarkdown=1.12*' \
      'r-forecast=8.6*' \
      'r-rsqlite=2.1*' \
      'r-reshape2=1.4*' \
      'r-nycflights13=1.0*' \
      'r-caret=6.0*' \
      'r-rcurl=1.95*' \
      'r-crayon=1.3*' \
      'r-randomforest=4.6*' \
      'r-htmltools=0.3*' \
      'r-sparklyr=1.0*' \
      'r-htmlwidgets=1.3*' \
      'r-hexbin=1.27*' && \
      conda clean -tipsy && \
      fix-permissions $HOME ; \
elif [[ $OPT_DOCKER_RUN_OUT == 0 ]] || [[ $OPT_DOCKER_RUN_OUT == 1 ]]; then
     echo -e "## Default repo\nlocal({r <- getOption(\"repos\")\n       r[\"CRAN\"] <- \"http://cran.r-project.org\"\n       options(repos=r)\n})\nSys.setenv(TZ=\"GMT\") " > $HOME/.Rprofile
     conda install --quiet  -y 'r-base=3.6.1' 'r-caret=6.0*'
else
     echo "Warning : R r-base=3.6 at rist of missing in setup!"
fi
pip install rpy2==3.2.7
pip install pyweatherbit==2.0.0
pip install gmplot==1.2.0
pip install folium==0.10.1
#
echo -e " install.packages(\"cli\") \n install.packages(\"readr\",repos=\"http://cloud.r-project.org/\", type=\"source\") \n install.packages(\"pracma\") \n install.packages(\"Metrics\") \n install.packages(\"reshape\") \n library(readr) \n sessionInfo() " > $HOME/R_install_packages.R
R -f $HOME/R_install_packages.R
