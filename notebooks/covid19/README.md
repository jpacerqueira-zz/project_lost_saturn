# Using Kalman Filter to Predict COVID19 Spread

This work  presents the implementation of an online real-time Kalman filter algorithm to predict the spread of COVID19 per given region.
Coronavirus(COVID19 or SARS-CoV-2) has recently caused major worldwide concern.
As the number of coronavirus cases reportedly increases, the spread of COVID19 is a serious threat to global health. 
In this work, we will try to predict the spread of coronavirus for each one of the infected regions. 
Fitting time series analysis and statistical algorithms to produce the best short term and long term prediction. 
An adaptive online Kalman filter provides us very good one-day predictions for each region.



### Kalman Filter Latest Predictions available  here
 Follow the setup of lost_saturn docker container.
* [Notebook - Latest Stats and Predictions by Joao.Cerqueira ](https://github.com/jpacerqueira/Jupyter_Spark_H2O_Kafka_Client_Setup/blob/master/notebooks/covid19/MY_COVID19-Prediction_00MMYYYY.ipynb)


### How to Run Notebook prediction for NN Days
 Follow the setup of lost_saturn docker container.
![Notebook - Run Yourself in this Docker container the Daily Predictions by Joao.Cerqueira](images/notebook-projections_run_in_container_project_lost_saturn_v1.png)


### Automate to run Notebook prediction daily with support script
 Setup a crontab for the provided script  ---  Runs everyday at 6h20 am to fetch data and produce 21dayForecast
 ###
 e7:~$ crontab -u notebookuser -l
 ###
 20 6 * * * /home/notebookuser/notebooks/covid19/daily-automation-notebook-21days.sh

### Links to Medium article can be found here
* [Using Kalman Filter to Predict Corona Virus Spread (Feb 22)](https://medium.com/@rank23/using-kalman-filter-to-predict-corona-virus-spread-72d91b74cc8)
* [Coronavirus Spread Updated Prediction Using Kalman Filter (Mar 1)](https://medium.com/analytics-vidhya/coronavirus-updated-prediction-using-kalman-filter-3ef8b7a72409)
