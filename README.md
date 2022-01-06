# Project lost_saturn 

   An setup with Jupyter Spark AutoML h2o.ai and client libraries Delta.io, PyArrow and Kafka
   Ideal to use Jupyter and tools exploring data in environments
   Docker (Ubunto 18.04 LTS) or Windows10 WSL (Windows Subsystem Linux)

   Setup Options
=========


   Option 1
===
     Run using Docker Desktop in your Laptop

       ./install-container.sh



   Option 2
=== 
   Run with Docker the container registred in [repo datascience-fullstack](https://hub.docker.com/r/jpacerqueira83/jupyter_datascience)
        

     Consume and run docker container with iptable port opening process

        ~ mac-u$ docker run  -it -p 9003:9003 -p 54321:54321 --cap-add=NET_ADMIN --name lost_saturn  jpacerqueira83/jupyter_container:stable

        
     Run Docker exec to start Jupyter after setup above finishes

        ~ mac-u$ docker exec -it lost_saturn /bin/bash -c "cd ; source .bashrc ; bash -x start-jupyter.sh ; sleep 4 ; cat notebooks/jupyter.log ; sleep infinity" 


   Option 3
===
   Run setup in Windows 10 with WSL app Ubunto 18.04 LTS 


     Consume package 

        ~ wsl-u$  cd ; git clone https://github.com/jpacerqueira/project_lost_saturn.git


     Execute installation
        ~ wsl-u$  cd ; cp project_lost_saturn/library_tools/*.sh . ; bash -x anaconda_setup.sh


   ![lost_saturn - container - Jupyter Notebooks DataScience](images/Docker_container_project_lost_saturn_v1.png)


   Issues and Workarrounds
=========


   Issue 1
===
   It is recommended to default OpenJDK8 and not OpenJDK11 or JAVA8(Oracle with an License) follow link 

     - Installation : https://www.linuxuprising.com/2019/02/install-any-oracle-java-jdk-version-in.html
     - This installation resolve my issue here : https://github.com/jupyter/jupyter/issues/248    
    

   Issue 2
===
   Mount additional driver in docker containers for optional JAVA8(Oracke)

     - Your local container may require to mount large files (git LFS) like Oracle JAVA installer


   Issue 3
===
   If Jupyter tools ( spark + h2o.ai + delta_lake:0.3) are not responsive in 1st time usage
               
                Please re-install in the following order 

               stop-jupyter ; install-jupyter-support-packs ; start-jupyter.sh

        (base) notebookuser@1662e83c8269:~$ pwd
        /home/notebookuser
        (base) notebookuser@1662e83c8269:~$ ls
        anaconda3  install-jupyter-support-packs.sh  java  knode_ds.err  knode_ds.out  library_tools  notebooks  python-additional-libraries  spark  start-jupyter.sh  stop-jupyter.sh
        (base) notebookuser@1662e83c8269:~$ netstat -anp | grep 9003
        (base) notebookuser@1662e83c8269:~$ bash -x stop-jupyter.sh 
        (base) notebookuser@1662e83c8269:~$ bash -x install-jupyter-support-packs.sh 
        (base) notebookuser@1662e83c8269:~$ bash -x start-jupyter.sh 
        (base) notebookuser@1662e83c8269:~$ tail -n 25 notebooks/jupyter.log  



   Licensing
=========
  Our "lost_saturn" docker container with jupyter SparkML and AutoML Ho2.ai is licensed under the Apache License, Version 2.0. See
  [LICENSE](https://github.com/jpacerqueira/Jupyter_Spark_H2O_Kafka_Client_Setup/blob/master/README.md) for the full license text.
 
  Apache Spark, Apache Arrow, H2o.ai.jar and Open-JDK8 are licensed under the Apache 2.0 License . Python, PyArrow and pi py H2o.ai under the GNU GPL License
           
  The end product here would benefit for an DevOps engineer with experience in docker-compose or Terraform, feel free to contribute.
  
  Usefull to experiment in the latest frameworks : 
  
  [Delta.io opensource DeltaLake](https://delta.io)
  
  [Delta Lake Sink readStream writeStream](https://docs.delta.io/latest/delta-streaming.html#delta-table-as-a-sink)
  
  [Spark Structure Streaming Programming with Delta Late](https://docs.delta.io/latest/delta-streaming.html#delta-table-as-a-sink)
    
  If you are a proeficient Data Engineer/Scientist use as it is, improve it, fix it, share it back!

===
