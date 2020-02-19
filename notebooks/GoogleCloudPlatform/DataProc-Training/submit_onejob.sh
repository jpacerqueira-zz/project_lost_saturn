#!/bin/bash
gcloud dataproc jobs submit pyspark \
       --cluster sparktobq \
       spark_analysis.py \
       -- --bucket=$1

