#!/usr/bin/env bash
# Install R default before libraries
####
conda install --quiet --yes \
     'r-base=3.6*' \
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
#
