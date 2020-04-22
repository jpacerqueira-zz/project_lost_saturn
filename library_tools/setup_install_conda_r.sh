#\env\bash
echo -e "## Default repo\nlocal({r <- getOption(\"repos\")\n       r[\"CRAN\"] <- \"http://cran.r-project.org\"\n       options(repos=r)\n})\nSys.setenv(TZ=\"GMT\") " > $HOME/.Rprofile
conda install -y r-base r-caret
pip install rpy2==3.2.7
pip install pyweatherbit==2.0.0
pip install gmplot==1.2.0
pip install folium==0.10.1
#
echo -e " install.packages(\"readr\",repos=\"http://cloud.r-project.org/\", type=\"source\") \n install.packages(\"pracma\") \n install.packages(\"Metrics\") \n install.packages(\"reshape\") \n library(readr) \n sessionInfo() " > $HOME/R_install_packages.R
R -f $HOME/R_install_packages.R
