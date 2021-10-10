#!/usr/bin/env bash
#
MYDATE=$1
DROP_NDAYS=$2
#
cat World_v2--Confirmed-1DayForecast--train-Dummy-Copy1.csv > World_v2--Confirmed-1Day_Forecast_--_train_${MYDATE}-copy0.csv
#          
#
tail -n +2 World\ \v2\ \--\ \Confirmed\ \-\ \drop_n_dataset_days_${DROP_NDAYS}_in_1Day\ \Forecast\ \--\ \train\ ${MYDATE}.csv >> World_v2--Confirmed-1Day_Forecast_--_train_${MYDATE}-copy0.csv
#
