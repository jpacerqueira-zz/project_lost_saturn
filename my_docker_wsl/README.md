

   1.) Execute a docker-composer environment for tensorflow with Jupyter

    -  1.1) require docker-machine and docker-composer
     
       (run) $ ./install-docker-machine.sh
       (run) $ ./install-docker-compose.sh 

    - 1.2 ) run full setup of docker/tenforflow/jupyter container machine

       (run) $ ./run-jupyter_fullstack_tensorflow2.0_h2o_docker_machine.sh



   2.) include Notebook to install additional libraries

       - Upload : Setup-System-Java-H2O-Spark.ipynb


   3.) Jupyter enviromment should load under http://127.0.0.1:9003

  ![alt text](images/Docker_container_TensorFlow_Jupyter_h2o.ai_example_image.png?raw=true "Docker Container Jupyter TenforFlow H2o.ai")
  
  
  
   4.) Also another alternative setup with notebook installation of libraries for demos like : Spark h2o.ai pyarrow
   
      (run) $ ./run-alternative-tensorflow_2.0_jupyter_docker_machine-2.sh
   
  ![alt text](images/Run-Alternative-Execute-Notebook-Capture.PNG?raw=true "Alternative Docker container with jupyer notebook Setup-System-Java-Spark-h2o.ai-pyarrow.ipynb run")
