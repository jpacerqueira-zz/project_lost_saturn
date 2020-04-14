#\env\bash
echo -e "## Default repo\nlocal({r <- getOption(\"repos\")\n       r[\"CRAN\"] <- \"http://cran.r-project.org\"\n       options(repos=r)\n})\nSys.setenv(TZ=\"GMT\") " > $HOME/.Rprofile
conda install -y r-base r-base-dev r-caret
pip install rpy2==3.2.7
#
echo -e " install.packages(\"readr\",repos=\"http://cloud.r-project.org/\", type=\"source\") \n library(readr) \n sessionInfo() " > $HOME/R_install_packages.R
R -f $HOME/R_install_packages.R
