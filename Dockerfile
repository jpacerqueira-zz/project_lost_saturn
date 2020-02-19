FROM ubuntu:18.04

RUN apt-get update -y && apt-get install -y apt-utils \
    sudo
RUN \
    groupadd -g 999 notebookuser && useradd -u 999 -g notebookuser -G sudo -m -s /bin/bash notebookuser && \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "notebookuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Customized the sudoers file for passwordless access to the notebookuser user!" && \
    echo "notebookuser user:";  su - notebookuser -c id

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get update -y && apt-get install -y curl \
    net-tools \
    iptables \
    iptables-persistent \
    wget \
    zip \
    unzip \
    tar \
    bzip2 

RUN apt-get update -y && apt-get install -y \
    python-qt4 \
    python-pyside \
    python-pip \
    python3-pip \
    python3-pyqt5 \
    vim \
    software-properties-common

ADD library_tools/*.sh /home/notebookuser/

RUN chmod 777 /home/notebookuser/*.sh

CMD mkdir -p /home/notebookuser/java/

ADD java_tools/*.* /home/notebookuser/java/

RUN chmod 777 /home/notebookuser/java/*.sh

CMD mkdir -p  /home/notebookuser/notebooks/data ; \
    mkdir -p  /home/notebookuser/notebooks/data/delta_business_terms ; \
    mkdir -p  /home/notebookuser/notebooks/data/delta_conviva ; \
    mkdir -p  /home/notebookuser/notebooks/data/delta_prostate ; \
    mkdir -p  /home/notebookuser/notebooks/data/delta_real_estate_term_definitions ; \
    mkdir -p  /home/notebookuser/notebooks/data/delta_terms_words_ngrams_real_estate ; \
    mkdir -p  /home/notebookuser/notebooks/data/terms_words_mortgages

ADD notebooks/*.* /home/notebookuser/notebooks/
ADD notebooks/data/*.*  /home/notebookuser/notebooks/data/
ADD notebooks/data/delta_business_terms/*.*  /home/notebookuser/notebooks/data/delta_business_terms/
ADD notebooks/data/delta_conviva/*.*  /home/notebookuser/notebooks/data/delta_conviva/
ADD notebooks/data/delta_prostate/*.*  /home/notebookuser/notebooks/data/delta_prostate/
ADD notebooks/data/delta_real_estate_term_definitions/*.*  /home/notebookuser/notebooks/data/delta_real_estate_term_definitions/
ADD notebooks/data/delta_terms_words_ngrams_real_estate/*.*  /home/notebookuser/notebooks/data/delta_terms_words_ngrams_real_estate/
ADD notebooks/data/terms_words_mortgages/*.*  /home/notebookuser/notebooks/data/terms_words_mortgages/

ADD setup-container-tools.sh /home/notebookuser/setup-container-tools.sh

RUN chmod 777 /home/notebookuser/*.sh

RUN chown notebookuser:notebookuser -R /home/notebookuser

EXPOSE 9003/tcp 54321/tcp

USER notebookuser

CMD export HOME=/home/notebookuser

CMD  export HOME=/home/notebookuser ; cd $HOME ; \
     sleep 59 ; \
     bash -x $HOME/setup-container-tools.sh .sh ; \
     sudo chown notebookuser:notebookuser -R $HOME ; \
     bash -x $HOME/library_tools/install-jupyter-support-packs.sh ; \
     bash -x $HOME/start-jupyter.sh ; \
     bash -x $HOME/stop-jupyter.sh ; \
     sleep infinity
#
