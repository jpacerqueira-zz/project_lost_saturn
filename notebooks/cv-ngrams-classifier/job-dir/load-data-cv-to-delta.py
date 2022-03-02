####################################################
###### Import Data : FROM PDF to Delta-Lake   ######
####################################################
#####
####################################################

# Get data From Folder
#
from datetime import datetime

datepath=datetime.today().strftime('%Y-%m-%d')
pdf_daily_path ="/job-dir/"+"data/raw_pdf/dt="+datepath+"/" 
#
json_daily_path="/job-dir/"+"data/raw_json/dt="+datepath+"/"
delta_json_structure="/job-dir/"+"data/delta/json-cv-pdf"

import numpy as np
import pandas as pd
#
import io
from pdfminer.converter import TextConverter
from pdfminer.pdfinterp import PDFPageInterpreter
from pdfminer.pdfinterp import PDFResourceManager
from pdfminer.pdfpage import PDFPage
#
import json
import os
from lib.local_pdfminer.json_exporter import export_as_json
from lib.local_pdfminer.json_exporter import export_as_json_page_n
#
from lib.local_sh.functions import copy_raw_sh_to_local
from lib.local_sh.functions import copy_local_to_raw_sh
#
import os
pdf_files=[val for sublist in [[os.path.join(i[0], j) for j in i[2]] for i in os.walk(pdf_daily_path)] for val in sublist]
# Meta comment to ease selecting text
#
os.system('mkdir -p '+json_daily_path)
for i, pdf_file in enumerate(pdf_files):    
    json_path = json_daily_path+"extract-"+datepath+"-"+str(i)+".json"
    data_csv=export_as_json_page_n(pdf_file, json_path)
#
### Input File in folder :  json_daily_path

##############################Execution##########################
#import findspark
#findspark.init()
#
import pyspark
from pyspark.sql import functions as pfunc
from pyspark.sql import SQLContext
from pyspark.sql import Window, types
import re
import pandas as pd
import numpy as np
from pandas import DataFrame
from pyspark.sql.types import IntegerType
from pyspark.sql.types import FloatType
from pyspark.sql.functions import udf
from pyspark.sql.functions import *
from scipy.stats import kstest
from scipy import stats
#
sc = pyspark.SparkContext(appName="Business_Dictionary-Ngrams_CVs-Delta")
sqlContext = SQLContext(sc)
#
# Join with Internal Curation Data in urltopredict staged folder
from pyspark.sql import functions as F
### remove viewerID
internaldata_df1=sqlContext.read.json(json_daily_path).persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
#
#
internaldata_df1.printSchema()
#
internaldata_df1.show(8)
#
df1=internaldata_df1.filter("filename IS NOT NULL").filter("pages IS NOT NULL").persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
#
df1.show(1,0)
##
df1.write.mode("overwrite").option("mergeSchema", "true").format("delta").save(delta_json_structure)
##
####
#sc.stop()
#
print("Data Load Done!")
#
#####################################
##############################
###### Load The Delta   ######
##############################
###
### Input delta in folder :  /data 
my_input_delta_table="/job-dir/"+"data/delta/json-cv-pdf"
delta_ngram_structure="/job-dir/"+"data/delta/cv-files-ngrams"
###
######
##############################Execution##########################
#
# Join with Internal Curation Data in urltopredict staged folder
from pyspark.sql import functions as F
### use version=1
version=1
## .option("versionAsOf", version)
delta_dataframe_df1=sqlContext.read.format("delta").load(my_input_delta_table)\
.persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
#
#
delta_dataframe_df1.printSchema()
delta_dataframe_df1.registerTempTable("delta_pdf_cv")
#
#### Expose most frequent CV Terms as NGram_n - Group of [1-6] words in CV
######
####
######
from pyspark.ml.feature import NGram, CountVectorizer, VectorAssembler, RegexTokenizer
from pyspark.ml import Pipeline

def build_ngrams(inputCol="pagei", n=6):

    ngrams = [
        NGram(n=i, inputCol="pagei", outputCol="{0}_grams".format(i))
        for i in range(1, n + 1)
    ]

    vectorizers = [
        CountVectorizer(inputCol="{0}_grams".format(i),
            outputCol="{0}_counts".format(i))
        for i in range(1, n + 1)
    ]

    assembler = [VectorAssembler(
        inputCols=["{0}_counts".format(i) for i in range(1, n + 1)],
        outputCol="features"
    )]

    return Pipeline(stages=ngrams + vectorizers + assembler)

regexTokenizer = RegexTokenizer(minTokenLength=1, gaps=False, pattern='\\w+|', inputCol="pagei", outputCol="words", toLowercase=True)

#######################################

#
pages_grouped=sqlContext.sql("select * from delta_pdf_cv where Filename != 'fw9' ")
pages_grouped=pages_grouped.select(col('Filename'),explode("pages.p_content").alias("pagei"))\
.select(col('Filename'),explode(split(col("pagei"), "\s+[1-99]\' \'s+")).alias("pagei")) ##[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+[1-99]\' \'s+
pages_grouped.printSchema()

tokenized_DF = regexTokenizer.transform(pages_grouped).select(col('Filename'),col("words").alias("pagei")).filter("pagei IS NOT NULL ")

tokenized_DF.printSchema()
tokenized_DF.show(5,0)

NgramDF = build_ngrams().fit(tokenized_DF).transform(tokenized_DF)
NgramDF.printSchema()
NgramDF.write.mode("overwrite").option("mergeSchema", "true").format("delta").save(delta_ngram_structure)
#
Ngram6DF=NgramDF.groupBy("6_grams").count().orderBy(col('count').desc())      
Ngram6DF.show(10,0)
#
Ngram5DF=NgramDF.groupBy("5_grams").count().orderBy(col('count').desc())      
Ngram5DF.show(10,0)
#
Ngram4DF=NgramDF.groupBy("4_grams").count().orderBy(col('count').desc())      
Ngram4DF.show(10,0)
#
Ngram3DF=NgramDF.groupBy("3_grams").count().orderBy(col('count').desc())      
Ngram3DF.show(10,0)
#
Ngram2DF=NgramDF.groupBy("2_grams").count().orderBy(col('count').desc())      
Ngram2DF.show(10,0)
#
Ngram1DF=NgramDF.groupBy("1_grams").count().orderBy(col('count').desc())      
Ngram1DF.show(10,0)
#
print("Load Ngrams to Delta Done")
print("Calculate top 10 most frequent 1,2,3,4,5,6 ngrams  - Finished!")
#######################################################
###### Import Skills Data : FROM CSV to Delta-Lake ####
#######################################################
#####
####################################################
#
skills_bulk_path="/job-dir/"+"data/raw_role_skills/*.csv"
#
delta_skills_structure="/job-dir/"+"data/delta/role_skills"
#
##############################Execution##########################
import findspark
findspark.init()
#
import pyspark
from pyspark.sql import functions as pfunc
from pyspark.sql import SQLContext
from pyspark.sql import Window, types
import re
import pandas as pd
import numpy as np
from pandas import DataFrame
from pyspark.sql.types import IntegerType
from pyspark.sql.types import FloatType
from pyspark.sql.functions import udf
from pyspark.sql.functions import *
from scipy.stats import kstest
from scipy import stats
#
# Join with Internal Curation Data in urltopredict staged folder
from pyspark.sql import functions as F
### remove viewerID
internaldata_df1=sqlContext.read.csv(skills_bulk_path,header='true').persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
#
#
internaldata_df1.printSchema()
#
internaldata_df1.show(8)
#
df1=internaldata_df1.filter("skill IS NOT NULL").filter("role IS NOT NULL").persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
#
df1.show(1,0)
##
df1.write.mode("overwrite").option("mergeSchema", "true").format("delta").save(delta_skills_structure)
##
print("Skills Load Done!")
#
#####################################
####
sc.stop()
#
print("All Loading Jobs Done!")
#######
