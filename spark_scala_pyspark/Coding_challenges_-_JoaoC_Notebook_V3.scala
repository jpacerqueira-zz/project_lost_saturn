// Databricks notebook source
// MAGIC %md # **Field Eng Coding Challenges**
// MAGIC 
// MAGIC ## Instructions
// MAGIC 
// MAGIC  1. Clone this notebook to your home folder
// MAGIC  1. Unless otherwise instructed, solve as many of the problems below as you can within the alloted time frame. Some of the challenges are more advanced than others and are expected to take more time to solve.
// MAGIC  1. You can create as many notebooks as you would like to answer the challenges 
// MAGIC  1. Notebooks should be presentable and should be able to execute succesfully with `Run All`
// MAGIC  1. Notebooks should be idempotent as well. Ideally, you'll also clean up after yourself (i.e. drop your tables)
// MAGIC  1. Once completed, publish your notebook: 
// MAGIC    * Choose the `Publish` item on the `File` menu
// MAGIC  1. Copy the URL(s) of the published notebooks and email them back to your Databricks contacts

// COMMAND ----------

// MAGIC %md 
// MAGIC ## Tips
// MAGIC The Databricks Guide (in the top of the Workspace) provides examples for how to use Databricks. You may want to start by reading through it.
// MAGIC 
// MAGIC ### Contexts Available
// MAGIC Note there are pre-existing contexts available to use in your notebooks:

// COMMAND ----------

sc

// COMMAND ----------

sqlContext

// COMMAND ----------

// MAGIC %md ### Using SQL in your cells
// MAGIC 
// MAGIC You can change to native SQL mode in your cells using the `%sql` prefix, demonstrated in the example below. Note that these include visualizations by default.

// COMMAND ----------

// MAGIC %sql show tables

// COMMAND ----------

// MAGIC %md ### Creating Visualizations from non-SQL Cells
// MAGIC 
// MAGIC When you needs to create a visualization from a cell where you are not writing native SQL, use the `display` function, as demonstrated below.

// COMMAND ----------

val same_query_as_above = sqlContext.sql("show tables")

// COMMAND ----------

display(same_query_as_above)

// COMMAND ----------

// MAGIC %md ## Challenges
// MAGIC ---
// MAGIC 
// MAGIC ### TPC-H Dataset
// MAGIC You're provided with a TPCH data set. The data is located in `/databricks-datasets/tpch/data-001/`. You can see the directory structure below:

// COMMAND ----------

display(dbutils.fs.ls("/databricks-datasets/tpch/data-001/"))

// COMMAND ----------

// MAGIC %md As you can see above, this dataset consists of 8 different folders with different datasets. The schema of each dataset is demonstrated below: 

// COMMAND ----------

// MAGIC %md ![test](http://kejser.org/wp-content/uploads/2014/06/image_thumb2.png)

// COMMAND ----------

// MAGIC %md You can take a quick look at each dataset by running the following Spark commmand. Feel free to explore and get familiar with this dataset

// COMMAND ----------

sc.textFile("/databricks-datasets/tpch/data-001/supplier/").take(1)

// COMMAND ----------

// MAGIC %md #### **Question #1**: Joins in Core Spark
// MAGIC Pick any two datasets and join them using Spark's API. Feel free to pick any two datasets. For example: `PART` and `PARTSUPP`. The goal of this exercise is not to derive anything meaningful out of this data but to demonstrate how to use Spark to join two datasets. For this problem you're **NOT allowed to use SparkSQL**. You can only use RDD API. You can use either Python or Scala to solve this problem.

// COMMAND ----------

val myPart=sc.textFile("dbfs:/databricks-datasets/tpch/data-001/part/*")
val myPartSupp=sc.textFile("dbfs:/databricks-datasets/tpch/data-001/partsupp/") //.take(5).tail(1)
// Map it
case class thePart(partkey:Int, name:String, mfgr:String, brand:String, typetype:String, size:String, container:String, retailprice:String, comment:String)
case class thePartSupp(partkey:Int, suppkey:Int, availqty:String, supplycost:String, comment:String, filler:String)

val mapPart=myPart.map(s=>s.split("\\|"))
                  .map(m=>thePart(m(0).toInt,m(1),m(2),m(3),m(4),m(5),m(6),m(7),m(8)))
val mapPartKV=mapPart.map(x=>(x.partkey,(x.name, x.mfgr, x.brand, x.typetype, x.size, x.container, x.retailprice)))
//              .toDF.show()
val mapPartSupp=myPart.map(s=>s.split("\\|"))
                  .map(n=>thePartSupp(n(0).toInt,n(1).toInt,n(2),n(3),n(4),n(5)))
val mapPartSuppKV=mapPartSupp.map(y=>(y.partkey,(y.suppkey,y.availqty,y.supplycost,y.comment,y.filler)))
//                .toDF.show()
// Join Maps
val myJoinPartPartSupp=mapPartKV.join(mapPartSuppKV) //,mapPart.partkey==mapPartSupp.partkey )
//                       
//
// Result
myJoinPartPartSupp.toDF()

// COMMAND ----------

// MAGIC %md #### **Question #2**: Joins With Spark SQL
// MAGIC Pick any two datasets and join them using SparkSQL API. Feel free to pick any two datasets. For example: PART and PARTSUPP. The goal of this exercise is not to derive anything meaningful out of this data but to demonstrate how to use Spark to join two datasets. For this problem you're **NOT allowed to use the RDD API**. You can only use SparkSQL API. You can use either Python or Scala to solve this problem. 

// COMMAND ----------

// classes
import org.apache.spark.sql._
import org.apache.spark.sql.types._

// Files
val myPartfile="dbfs:/databricks-datasets/tpch/data-001/part/*"
val myPartSuppfile="dbfs:/databricks-datasets/tpch/data-001/partsupp/*"

// Schemas
//case class thePart(partkey:Int, name:String, mfgr:String, brand:String, typetype:String, size:String, container:String, retailprice:String, comment:String)
//val thePart = StructType.FromDDL("partkey integer, name string, mfgr string, brand string, typetype string, container string, retailprice string, comment string")
 val thePart =
   StructType(Array(
     StructField("partkey", IntegerType, true),
     StructField("name", StringType, false),
     StructField("mfgr", StringType, false),
     StructField("brand", StringType, false),
     StructField("typetype", StringType, false),
     StructField("container", StringType, false),
     StructField("retailprice", StringType, false),
     StructField("comment", StringType, false)))

//case class thePartSupp(partkey:Int, suppkey:Int, availqty:String, supplycost:String, comment:String, filler:String)
//val thePartSupp = StructType.FromDDL("partkey integer, suppkey integer, availqty string, supplycost string, comment string, filler string")
 val thePartSupp =
   StructType(Array(
     StructField("partkey", IntegerType, true),
     StructField("suppkey", IntegerType, false),
     StructField("availqtv", StringType, false),
     StructField("supplycost", StringType, false),
     StructField("comment", StringType, false),
     StructField("container", StringType, false)))

// Use the sqlContext to create our Dataframe
val dataPartCollectionDF = sqlContext.read.format("csv").option("delimiter", "|").option("header", "false").option("mode", "PERMISSIVE").option("InferSchema", "true").schema(thePart).load(myPartfile)
val dataPartSuppCollectionDF = sqlContext.read.format("csv").option("delimiter", "|").option("header", "false").option("mode", "PERMISSIVE").option("InferSchema", "true").schema(thePartSupp).load(myPartSuppfile)

//dataPartCollectionDF.printSchema()
//dataPartCollectionDF.take(1)
//dataPartSuppCollectionDF.printSchema()
//dataPartSuppCollectionDF.take(1)

// Join Datasets
dataPartCollectionDF.createOrReplaceTempView("part")
dataPartSuppCollectionDF.createOrReplaceTempView("partsupp")

val join_df=sql("select * from part join partsupp where part.partkey=partsupp.partkey")

join_df.show()


// COMMAND ----------

// MAGIC %md #### **Question #3**: Alternate Data Formats
// MAGIC The given dataset above is in raw text storage format. What other data storage format can you suggest to optimize the performance of our Spark workload if we were to frequently scan and read this dataset. Please come up with a code example and explain why you decide to go with this approach. Please note that there's no completely correct answer here. We're interested to hear your thoughts and see the implementation details.shell/1282

// COMMAND ----------

// Answer : 
//           It is possible persist the results of the previous join
//           In a better format for subsequent reading processes
//           An option can be a new Parquet schema infered while writting output of join
//           This can also be stored as a permanent table if required for many different workflows.

// Previous Notebook Structure - Begin
// classes
import org.apache.spark.sql._
import org.apache.spark.sql.types._

// Files
val myPartfile="dbfs:/databricks-datasets/tpch/data-001/part/*"
val myPartSuppfile="dbfs:/databricks-datasets/tpch/data-001/partsupp/*"

// Schemas
 val thePart =
   StructType(Array(
     StructField("partkey", IntegerType, true),
     StructField("name", StringType, false),
     StructField("mfgr", StringType, false),
     StructField("brand", StringType, false),
     StructField("typetype", StringType, false),
     StructField("container", StringType, false),
     StructField("retailprice", StringType, false),
     StructField("comment", StringType, false)))

 val thePartSupp =
   StructType(Array(
     StructField("partkey", IntegerType, true),
     StructField("suppkey", IntegerType, false),
     StructField("availqtv", StringType, false),
     StructField("supplycost", StringType, false),
     StructField("comment", StringType, false),
     StructField("container", StringType, false)))

// Use the sqlContext to create our Dataframe
val dataPartCollectionDF = sqlContext.read.format("csv").option("delimiter", "|").option("header", "false").option("mode", "PERMISSIVE").option("InferSchema", "true").schema(thePart).load(myPartfile)
val dataPartSuppCollectionDF = sqlContext.read.format("csv").option("delimiter", "|").option("header", "false").option("mode", "PERMISSIVE").option("InferSchema", "true").schema(thePartSupp).load(myPartSuppfile)

//dataPartCollectionDF.printSchema()
//dataPartCollectionDF.take(1)
//dataPartSuppCollectionDF.printSchema()
//dataPartSuppCollectionDF.take(1)

// Join Datasets
dataPartCollectionDF.createOrReplaceTempView("part")
dataPartSuppCollectionDF.createOrReplaceTempView("partsupp")

// Previous Notebook Structure - End

val join_df=sql("select part.partkey as partkey,part.name as name ,part.mfgr as mfgr,part.brand as brand,part.typetype as typetype,part.container as container,part.retailprice as retailprice,part.comment as part_comment,partsupp.suppkey as suppkey,partsupp.availqtv as availqtv, partsupp.supplycost as supplycost,partsupp.comment as partsupp_comment, partsupp.container partsupp_container from part join partsupp where part.partkey=partsupp.partkey")

join_df.createOrReplaceTempView("partjoinpartsupp_raw")

// HiveQL Join table Load
val sql_drop_previous_table = "DROP TABLE IF EXISTS partjoinpartsupp"
val sql_publish_join = "CREATE TABLE  partjoinpartsupp USING hive OPTIONS(fileFormat 'parquet') SELECT * FROM partjoinpartsupp_raw"
val sql_select_join = " SELECT * FROM partjoinpartsupp limit 3"

val drop_prev = sqlContext.sql(sql_drop_previous_table)
val load_join = sqlContext.sql(sql_publish_join)
val select_of_join = sqlContext.sql(sql_select_join).show()

// COMMAND ----------

// MAGIC %md ### Baby Names Dataset
// MAGIC 
// MAGIC This dataset comes from a website referenced by [Data.gov](http://catalog.data.gov/dataset/baby-names-beginning-2007). It lists baby names used in the state of NY from 2007 to 2012.
// MAGIC 
// MAGIC The following cells run commands that copy this file to the cluster.

// COMMAND ----------

// MAGIC %fs rm dbfs:/tmp/rows.json

// COMMAND ----------

import java.net.URL
import java.io.File
import org.apache.commons.io.FileUtils

val tmpFile = new File("/tmp/rows.json")
FileUtils.copyURLToFile(new URL("https://health.data.ny.gov/api/views/jxy9-yhdk/rows.json?accessType=DOWNLOAD"), tmpFile)

// COMMAND ----------

// MAGIC %fs mv file:/tmp/rows.json dbfs:/tmp/rows.json

// COMMAND ----------

// MAGIC %fs head dbfs:/tmp/rows.json

// COMMAND ----------

// MAGIC %md #### **Question #1**: Spark SQL's Native JSON Support
// MAGIC Use Spark SQL's native JSON support to create a temp table you can use to query the data (you'll use the `registerTempTable` operation). Show a simple sample query.

// COMMAND ----------

import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._

// Function for turning JSON strings into DataFrames.
def jsonToDataFrame(json: String, schema: StructType = null): DataFrame = {
  // SparkSessions are available with Spark 2.0+
  val reader = spark.read
  Option(schema).foreach(reader.schema)
  //reader.json(sc.parallelize(Array(json)))
  reader.json(Seq(json).toDS)
}

// Files
val myjsongovfile="dbfs:/tmp/rows.json"

// 1. Load file as one string
val file1 = sc.wholeTextFiles(myjsongovfile)
val hole_file = file1.take(1)(0)._2 //file1.collect.foreach(t=>println(t._2)) //

// 2. display meta or data
display(jsonToDataFrame(hole_file).select("meta.view.columns.name") )
val metastructure = jsonToDataFrame(hole_file).select("meta.view.columns.name").take(1).toString()
//val newNames = Seq(metastructure)
val newNames = Seq("sid","id","position","created_at","created_meta","updated_at","updated_meta","meta","Year","First Name","County","Sex","Count")

val babynames_meta_data_DF = jsonToDataFrame(hole_file).select(explode_outer('data))
                             .select('col.getItem(0) as 'x1, 'col.getItem(1) as 'x2,'col.getItem(2) as 'x3,'col.getItem(3) as 'x4,'col.getItem(4) as 'x5,'col.getItem(5) as 'x6,'col.getItem(6) as 'x7,'col.getItem(7) as 'x8,'col.getItem(8) as 'x9,'col.getItem(9) as 'x10,'col.getItem(10) as 'x11,'col.getItem(11) as 'x12,'col.getItem(12) as 'x13).toDF(newNames: _*) //.toDF()//

val babynames_meta_data_pers_DF = babynames_meta_data_DF.persist()
// Register Temp Table
babynames_meta_data_pers_DF.createOrReplaceTempView("babynames_meta_data_temp")

// HiveQL select from temp_table
val sql_select_temp = " SELECT * FROM babynames_meta_data_temp limit 3"
val select_of_temp = sqlContext.sql(sql_select_temp)
display(sqlContext.sql(sql_select_temp))

// COMMAND ----------

// MAGIC %md #### **Question #2**: Working with Nested Data
// MAGIC What does the nested schema of this dataset look like? How can you bring these nested fields up to the top level in a DataFrame?

// COMMAND ----------

import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._

// Function for turning JSON strings into DataFrames.
def jsonToDataFrame(json: String, schema: StructType = null): DataFrame = {
  // SparkSessions are available with Spark 2.0+
  val reader = spark.read
  Option(schema).foreach(reader.schema)
  //reader.json(sc.parallelize(Array(json)))
  reader.json(Seq(json).toDS)
}

// Files
val myjsongovfile="dbfs:/tmp/rows.json"

// 1. Load file as one string
val file1 = sc.wholeTextFiles(myjsongovfile)
val hole_file = file1.take(1)(0)._2 //file1.collect.foreach(t=>println(t._2)) //

// 2. display meta or data
display(jsonToDataFrame(hole_file).select("meta.view.columns.name"))
val metastructure = jsonToDataFrame(hole_file).select("meta.view.columns.name").collect()
//val newNames = Seq(metastructure)
val newNames = Seq("sid","id","position","created_at","created_meta","updated_at","updated_meta","meta","Year","First Name","County","Sex","Count")

val babynames_meta_data_DF = jsonToDataFrame(hole_file).select(explode_outer('data))
                             .select('col.getItem(0) as 'x1, 'col.getItem(1) as 'x2,'col.getItem(2) as 'x3,'col.getItem(3) as 'x4,'col.getItem(4) as 'x5,'col.getItem(5) as 'x6,'col.getItem(6) as 'x7,'col.getItem(7) as 'x8,'col.getItem(8) as 'x9,'col.getItem(9) as 'x10,'col.getItem(10) as 'x11,'col.getItem(11) as 'x12,'col.getItem(12) as 'x13).toDF(newNames: _*) //.toDF()//

val babynames_meta_data_pers_DF = babynames_meta_data_DF.persist()
// Register Temp Table
babynames_meta_data_pers_DF.createOrReplaceTempView("babynames_meta_data_temp")

// HiveQL select from temp_table
val sql_select_temp = " SELECT * FROM babynames_meta_data_temp limit 3"
val select_of_temp = sqlContext.sql(sql_select_temp)
//display(sqlContext.sql(sql_select_temp))

// COMMAND ----------

// MAGIC %md #### **Question #3**: Executing Full Data Pipelines
// MAGIC Create a second version of the answer to Question 2, and make sure one of your queries makes the original web call every time a query is run, while another version only executes the web call one time.

// COMMAND ----------

// MAGIC %fs rm dbfs:/tmp/rows.json

// COMMAND ----------

import java.net.URL
import java.io.File
import org.apache.commons.io.FileUtils

val tmpFile = new File("/tmp/rows.json")
FileUtils.copyURLToFile(new URL("https://health.data.ny.gov/api/views/jxy9-yhdk/rows.json?accessType=DOWNLOAD"), tmpFile)

// COMMAND ----------

// MAGIC %fs mv file:/tmp/rows.json dbfs:/tmp/rows.json

// COMMAND ----------

// MAGIC %fs head dbfs:/tmp/rows.json

// COMMAND ----------

import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._

// Convenience function for turning JSON strings into DataFrames.
def jsonToDataFrame(json: String, schema: StructType = null): DataFrame = {
  // SparkSessions are available with Spark 2.0+
  val reader = spark.read
  Option(schema).foreach(reader.schema)
  //reader.json(sc.parallelize(Array(json)))
  reader.json(Seq(json).toDS)
}

// Fetch WebFile dynamically
import java.net.URL
import java.io.File
import org.apache.commons.io.FileUtils


//////////////////
/// Need to find a dynamic load of the file for here
/////////////////
val tmpFile = new File("dbfs:/tmp/rows.json")
FileUtils.copyURLToFile(new URL("https://health.data.ny.gov/api/views/jxy9-yhdk/rows.json?accessType=DOWNLOAD"), tmpFile)

// Files
val myjsongovfile="dbfs:/tmp/rows.json"

// 1. Load file as one string
val file1 = sc.wholeTextFiles(myjsongovfile)
val hole_file = file1.take(1)(0)._2 //file1.collect.foreach(t=>println(t._2)) //

// 2. display meta or data
display(jsonToDataFrame(hole_file).select("meta.view.columns.name"))
val metastructure = jsonToDataFrame(hole_file).select("meta.view.columns.name").collect()
//val newNames = Seq(metastructure)
val newNames = Seq("sid","id","position","created_at","created_meta","updated_at","updated_meta","meta","Year","First_Name","County","Sex","Count")

val babynames_meta_data_DF = jsonToDataFrame(hole_file).select(explode_outer('data))
                             .select('col.getItem(0) as 'x1, 'col.getItem(1) as 'x2,'col.getItem(2) as 'x3,'col.getItem(3) as 'x4,'col.getItem(4) as 'x5,'col.getItem(5) as 'x6,'col.getItem(6) as 'x7,'col.getItem(7) as 'x8,'col.getItem(8) as 'x9,'col.getItem(9) as 'x10,'col.getItem(10) as 'x11,'col.getItem(11) as 'x12,'col.getItem(12) as 'x13).toDF(newNames: _*) //.toDF()//

val babynames_meta_data_pers_DF = babynames_meta_data_DF.persist()
// Register Temp Table
babynames_meta_data_pers_DF.createOrReplaceTempView("babynames_meta_data_temp")

// HiveQL select from temp_table
val sql_select_temp = " SELECT * FROM babynames_meta_data_temp limit 10"
val select_of_temp = sqlContext.sql(sql_select_temp)
display(sqlContext.sql(sql_select_temp))

// HiveQL select from temp_table to default table
val sql_drop_previous_table = "DROP TABLE IF EXISTS babynames_meta_data"
val sql_publish_table = "CREATE TABLE  babynames_meta_data USING hive OPTIONS(fileFormat 'parquet') SELECT sid,id,position,created_at,created_meta,updated_at,updated_meta,meta,Year as year,First_Name as first_name,County as county,Sex as sex,Count as count FROM babynames_meta_data_temp"

val drop_prev = sqlContext.sql(sql_drop_previous_table)
val load_join = sqlContext.sql(sql_publish_table)


// COMMAND ----------

// MAGIC %md #### **Question #4**: Analyzing the Data
// MAGIC 
// MAGIC Using the tables you created, create a simple visualization that shows what is the most popular first letters baby names to start with in each year.

// COMMAND ----------

val analyse_babies1 = sqlContext.sql("select substring(first_name, 1, 1) as first_char_name , year  from babynames_meta_data limit 100000000 ").persist()
// Register Temp Table
analyse_babies1.createOrReplaceTempView("babynames_fname_temp")
val analyse_babies2 = sqlContext.sql(" select COUNT(first_char_name) as count, year,first_char_name  FROM babynames_fname_temp group by year,first_char_name order by count desc")

display(analyse_babies2)

// COMMAND ----------

// MAGIC %md ### Log Processing
// MAGIC 
// MAGIC The following data comes from the _Learning Spark_ book.

// COMMAND ----------

display(dbutils.fs.ls("/databricks-datasets/learning-spark/data-001/fake_logs"))

// COMMAND ----------

println(dbutils.fs.head("/databricks-datasets/learning-spark/data-001/fake_logs/log1.log"))

// COMMAND ----------

println(dbutils.fs.head("/databricks-datasets/learning-spark/data-001/fake_logs/log2.log"))

// COMMAND ----------

// MAGIC %md #### **Question #1**: Parsing Logs
// MAGIC Parse the logs in to a DataFrame/Spark SQL table that can be queried. This should be done using the Dataset API.

// COMMAND ----------

//
// classes
import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._

//
case class Nlogs(ip: String, timestamp: java.sql.Timestamp, op: String, device_info: String)
// Format different from :: W3C Extended Log File Format 
val log_name="dbfs:/databricks-datasets/learning-spark/data-001/fake_logs/*.log"

val logschema =
   StructType(Array(
     StructField("ip", StringType, true),
     StructField("filler", StringType, false),
     StructField("timestamp_op", StringType, false),
     StructField("device_info", StringType, false)))
val  log_files :Dataset[Row] = sqlContext.read.option("sep", "-").schema(logschema).csv(log_name)
//log_files.printSchema()

val log1DS :Dataset[Row] = log_files.filter("ip IS NOT NULL")
  .drop(log_files("filler"))
  .withColumn("timestamp_str", upper(expr("substring(timestamp_op, locate('[',timestamp_op)+1 , locate(']',timestamp_op)-3)")))
  .withColumn("op", expr("substring(timestamp_op, locate(']',timestamp_op)+1 , length(timestamp_op)-1)"))
//log1DS.printSchema()

val log2DS :Dataset[Row] = log1DS
  .withColumn("timestamp", unix_timestamp(log1DS("timestamp_str"),"dd/MMM/yyyy:HH:mm:ss +SSSS").cast(TimestampType))
  .select('ip,'timestamp,'op,'device_info)
log2DS.printSchema()

val logDS = log2DS.as[Nlogs]
val tableNlogs = logDS.toDF.write.mode("overwrite").format("parquet").saveAsTable("default.nlogs")
logDS.take(1)

// COMMAND ----------

// MAGIC %md #### **Question #2**: Analysis
// MAGIC Generate some insights from the log data.

// COMMAND ----------

import org.apache.spark.sql.expressions.Window

// DataSet Class
case class Nlogs(ip: String, timestamp: java.sql.Timestamp, op: String, device_info: String)

// Read table
val tableNlogs=sqlContext.read.table("default.nlogs").as[Nlogs]

// Distinct type of Operations in timeframe windows
// partition records into two groups M
// * others
val byOccurMozilla = Window.partitionBy('ip,'timestamp,'device_info contains "%Mozilla")

// count how many times per ip, timestamp, we use Mozilla
val ipMozilla = tableNlogs.select('timestamp,'ip, count('timestamp) over byOccurMozilla as "count_mozilla" , 'device_info).orderBy('timestamp)
// Display How many time each IP log browser as Mozila per timestamp
display(ipMozilla)

// COMMAND ----------

// MAGIC %md
// MAGIC ### CSV Parsing
// MAGIC The following examples involove working with simple CSV data

// COMMAND ----------

// MAGIC %md #### **Question #1**: CSV Header Rows
// MAGIC Given the simple RDD `full_csv` below, write the most efficient Spark job you can to remove the header row

// COMMAND ----------

val full_csv = sc.parallelize(Array(
  "col_1, col_2, col_3",
  "1, ABC, Foo1",
  "2, ABCD, Foo2",
  "3, ABCDE, Foo3",
  "4, ABCDEF, Foo4",
  "5, DEF, Foo5",
  "6, DEFGHI, Foo6",
  "7, GHI, Foo7",
  "8, GHIJKL, Foo8",
  "9, JKLMNO, Foo9",
  "10, MNO, Foo10"))

// Joao-answer
val vars = full_csv.first()
val vars1 = full_csv.take(1)
val header = sc.parallelize(vars1)
val fullcsvDF = full_csv.subtract(header:RDD[String]) //.filter(lambda x => x != vars) //
fullcsvDF.toDF(vars).show()


// COMMAND ----------

// MAGIC %md #### **Question #2**: SparkSQL Dataframes
// MAGIC Using the `full_csv` RDD above, write code that results in a DataFrame where the schema was created programmatically based on the heard row. Create a second RDD similair to `full_csv` and uses the same function(s) you created in this step to make a Dataframe for it.

// COMMAND ----------

val full_csv = sc.parallelize(Array(
  "col_1, col_2, col_3",
  "1, ABC, Foo1",
  "2, ABCD, Foo2",
  "3, ABCDE, Foo3",
  "4, ABCDEF, Foo4",
  "5, DEF, Foo5",
  "6, DEFGHI, Foo6",
  "7, GHI, Foo7",
  "8, GHIJKL, Foo8",
  "9, JKLMNO, Foo9",
  "10, MNO, Foo10"))

// Joao-answer is same as 1.
val vars = full_csv.first()
val vars1 = full_csv.take(1)
val header = sc.parallelize(vars1)
val fullcsvDF = full_csv.subtract(header:RDD[String]) //.filter(lambda x => x != vars) //
fullcsvDF.toDF(vars).show()

// COMMAND ----------

// MAGIC %md #### **Question #3**: Parsing Pairs
// MAGIC 
// MAGIC Write a Spark job that processes comma-seperated lines that look like the below example to pull out Key Value pairs. 
// MAGIC 
// MAGIC Given the following data:
// MAGIC 
// MAGIC ~~~
// MAGIC Row-Key-001, K1, 10, A2, 20, K3, 30, B4, 42, K5, 19, C20, 20
// MAGIC Row-Key-002, X1, 20, Y6, 10, Z15, 35, X16, 42
// MAGIC Row-Key-003, L4, 30, M10, 5, N12, 38, O14, 41, P13, 8
// MAGIC ~~~
// MAGIC 
// MAGIC You'll want to create an RDD that contains the following data:
// MAGIC 
// MAGIC ~~~
// MAGIC Row-Key-001, K1
// MAGIC Row-Key-001, A2
// MAGIC Row-Key-001, K3
// MAGIC Row-Key-001, B4
// MAGIC Row-Key-001, K5
// MAGIC Row-Key-001, C20
// MAGIC Row-Key-002, X1
// MAGIC Row-Key-002, Y6
// MAGIC Row-Key-002, Z15
// MAGIC Row-Key-002, X16
// MAGIC Row-Key-003, L4
// MAGIC Row-Key-003, M10
// MAGIC Row-Key-003, N12
// MAGIC Row-Key-003, O14
// MAGIC Row-Key-003, P13
// MAGIC ~~~

// COMMAND ----------

import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types._

val aslines_csv = sc.parallelize(Array(
  "Row-Key-001, K1, 10, A2, 20, K3, 30, B4, 42, K5, 19, C20, 20"
  ,
  "Row-Key-002, X1, 20, Y6, 10, Z15, 35, X16, 42",
  "Row-Key-003, L4, 30, M10, 5, N12, 38, O14, 41, P13, 8"
))

//def isAllDigits(x: String) = x.matches("^\\d+$")
//def noAllDigit(x:String) = if (isAllDigits(x) == true) true else false
//val patternvalue = " ([A-Z])([0-9]+)"
// aslines_csv.zipWithIndex().map{ case (line, i) => (i+1).toString + "," + line }.
                                                                   
val aslines_csvRDD = aslines_csv.map(_.split(",")).map{ case line =>
   // Unit function Per line 
   line.map(x => (x.split(",")(0), x)).flatMap( _._2.split(",") ).filter{x => (x.matches(" ([A-Z])([0-9]+)")) || (x.matches("Row-Key-([0-9]+)")) }.toList}
   // convert
   .map(x => (x(0), x)).map{ case (x,y) => (x, y.filter{ x => (x.matches(" ([A-Z])([0-9]+)"))} ) }
   .zipWithIndex().map{ case (line, i) =>(i+1,line)}


   //.flatMap{case (x.map{ case  line => line.flatMap( _.convert) },y) => (x, y.get(_))} 
   //.map{ case line => line.map(x => (x.split(",")(0), x))} //.map(_.toList).flatMap((_._1._1,_))
   //.map(_.toList)
   //.zipWithIndex().map{ case (line, i) =>(i+1,line)}
   //.zipWithIndex() //.flatMap( case (arr,key) => (arr(0),arr) )

val aslines_csvCLL = aslines_csvRDD.collect()

//def convert: ( (Int,(String, List[String])) => List[(Int,String,String)] ) = { case (ind,(key,value)) => value.split(",").map(str => (ind, key, value))}

// Unit function Per line 
val aslines_csvtRDD=aslines_csvCLL//.map{ case  line => line.flatMap( _.convert) } //.flatMap(convert)  
aslines_csvtRDD.foreach(println)


// COMMAND ----------

val lt =  List((1,("Row-Key-001",List(" K1", " A2", " K3", " B4", " K5", " C20"))),
               (2,("Row-Key-002",List(" X1", " Y6", " Z15", " X16"))),
               (3,("Row-Key-003",List(" L4", " M10", " N12", " O14", " P13"))))

def convert1: ( (Int,(String, List[String])) => List[(Int,String,String)] ) = { case (ind,(key,value)) => value.split(",").map(str => (ind, key, value)).toList}

val t = lt.flatMap(convert1)


// COMMAND ----------

// MAGIC %md
// MAGIC #### Question #4 Create Tables Programmatically And Cache The Table
// MAGIC 
// MAGIC Create a table using Scala or Python
// MAGIC 
// MAGIC * Use `CREATE EXTERNAL TABLE` in SQL, or `DataFrame.saveAsTable()` in Scala or Python, to register tables.
// MAGIC * Please refer to the [Accessing Data](/#workspace/databricks_guide/03 Accessing Data/0 Accessing Data) guide for how to import specific data types.
// MAGIC 
// MAGIC ### Temporary Tables
// MAGIC * Within each Spark cluster, temporary tables registered in the `sqlContext` with `DataFrame.registerTempTable` will also be shared across the notebooks attached to that Databricks cluster.
// MAGIC   * Run `someDataFrame.registerTempTable(TEMP_TABLE_NAME)` to give register a table.
// MAGIC * These tables will not be visible in the left-hand menu, but can be accessed by name in SQL and DataFrames.

// COMMAND ----------

//  I have answerd this already in above cases
// . // ___ follow my answer for  ____   Question #3: Alternate Data Formats
// . // ___ follow my answer for  ____   Question #1: Parsing Logs

// COMMAND ----------

// MAGIC %md 
// MAGIC #### Question #5 DataFrame UDFs and DataFrame SparkSQL Functions
// MAGIC 
// MAGIC Below we've created a small DataFrame. You should use DataFrame API functions and UDFs to accomplish two tasks.
// MAGIC 
// MAGIC 1. You need to parse the State and city into two different columns.
// MAGIC 2. You need to get the number of days in between the start and end dates. You need to do this two ways.
// MAGIC   - Firstly, you should use SparkSQL functions to get this date difference.
// MAGIC   - Secondly, you should write a udf that gets the number of days between the end date and the start date.

// COMMAND ----------

// MAGIC %python
// MAGIC 
// MAGIC from pyspark.sql import functions as F
// MAGIC from pyspark.sql.types import *
// MAGIC 
// MAGIC # Build an example DataFrame dataset to work with. 
// MAGIC dbutils.fs.rm("/tmp/dataframe_sample.csv", True)
// MAGIC dbutils.fs.put("/tmp/dataframe_sample.csv", """id|end_date|start_date|location
// MAGIC 1|2015-10-14 00:00:00|2015-09-14 00:00:00|CA-SF
// MAGIC 2|2015-10-15 01:00:20|2015-08-14 00:00:00|CA-SD
// MAGIC 3|2015-10-16 02:30:00|2015-01-14 00:00:00|NY-NY
// MAGIC 4|2015-10-17 03:00:20|2015-02-14 00:00:00|NY-NY
// MAGIC 5|2015-10-18 04:30:00|2014-04-14 00:00:00|CA-SD
// MAGIC """, True)
// MAGIC 
// MAGIC formatPackage = "csv" if sc.version > '1.6' else "com.databricks.spark.csv"
// MAGIC df = sqlContext.read.format(formatPackage).options(header='true', delimiter = '|').load("/tmp/dataframe_sample.csv")
// MAGIC df.printSchema()
// MAGIC #
// MAGIC #
// MAGIC # Using PySpark python3 spark.2.4.2
// MAGIC # 1.) Parse State and City in Two Difefrent Columns
// MAGIC df.persist()
// MAGIC #
// MAGIC from pyspark.sql.functions import *
// MAGIC df1 = df.withColumn("state",expr("substring(location,1,2)")).withColumn("city",expr("substring(location,4,5)"))
// MAGIC #.withColumn("state",expr("substring(location,1,locate('-',location)-1"))\
// MAGIC #.withColumn("city",expr("substring(location, locate('-',location)+1 , length(location)-1)"))
// MAGIC #
// MAGIC #
// MAGIC df1.printSchema()
// MAGIC df1.take(1)
// MAGIC #
// MAGIC #df.unpersist()

// COMMAND ----------

// MAGIC %python
// MAGIC 
// MAGIC #from pyspark.sql import functions as F
// MAGIC from pyspark.sql.types import *
// MAGIC 
// MAGIC # Build an example DataFrame dataset to work with. 
// MAGIC dbutils.fs.rm("/tmp/dataframe_sample.csv", True)
// MAGIC dbutils.fs.put("/tmp/dataframe_sample.csv", """id|end_date|start_date|location
// MAGIC 1|2015-10-14 00:00:00|2015-09-14 00:00:00|CA-SF
// MAGIC 2|2015-10-15 01:00:20|2015-08-14 00:00:00|CA-SD
// MAGIC 3|2015-10-16 02:30:00|2015-01-14 00:00:00|NY-NY
// MAGIC 4|2015-10-17 03:00:20|2015-02-14 00:00:00|NY-NY
// MAGIC 5|2015-10-18 04:30:00|2014-04-14 00:00:00|CA-SD
// MAGIC """, True)
// MAGIC 
// MAGIC formatPackage = "csv" if sc.version > '1.6' else "com.databricks.spark.csv"
// MAGIC df2 = sqlContext.read.format(formatPackage).options(header='true', delimiter = '|').load("/tmp/dataframe_sample.csv")
// MAGIC df2.printSchema()
// MAGIC #
// MAGIC df2.persist()
// MAGIC #
// MAGIC # Using PySpark python3 spark.2.4.2
// MAGIC #
// MAGIC # 2.1) Use SparkSQL functions
// MAGIC #
// MAGIC #
// MAGIC from pyspark.sql.functions import unix_timestamp
// MAGIC #
// MAGIC df21=df2\
// MAGIC .withColumn("duration_ndays", datediff(col("end_date"),col("start_date")).alias('diff'))
// MAGIC #
// MAGIC df21.printSchema()
// MAGIC df21.take(5)
// MAGIC #
// MAGIC #
// MAGIC #df2.unpersist()

// COMMAND ----------

// MAGIC %python
// MAGIC 
// MAGIC #from pyspark.sql import functions as F
// MAGIC from pyspark.sql.types import *
// MAGIC 
// MAGIC # Build an example DataFrame dataset to work with. 
// MAGIC dbutils.fs.rm("/tmp/dataframe_sample.csv", True)
// MAGIC dbutils.fs.put("/tmp/dataframe_sample.csv", """id|end_date|start_date|location
// MAGIC 1|2015-10-14 00:00:00|2015-09-14 00:00:00|CA-SF
// MAGIC 2|2015-10-15 01:00:20|2015-08-14 00:00:00|CA-SD
// MAGIC 3|2015-10-16 02:30:00|2015-01-14 00:00:00|NY-NY
// MAGIC 4|2015-10-17 03:00:20|2015-02-14 00:00:00|NY-NY
// MAGIC 5|2015-10-18 04:30:00|2014-04-14 00:00:00|CA-SD
// MAGIC """, True)
// MAGIC 
// MAGIC formatPackage = "csv" if sc.version > '1.6' else "com.databricks.spark.csv"
// MAGIC df2 = sqlContext.read.format(formatPackage).options(header='true', delimiter = '|').load("/tmp/dataframe_sample.csv")
// MAGIC df2.printSchema()
// MAGIC #
// MAGIC df2.persist()
// MAGIC #
// MAGIC # Using PySpark python3 spark.2.4.2
// MAGIC #
// MAGIC # 2.2) USE UDF
// MAGIC #
// MAGIC from pyspark.sql.functions import *
// MAGIC #
// MAGIC #
// MAGIC # define timedelta function (obtain duration in seconds)
// MAGIC def dateDiff(end_date,start_date): 
// MAGIC     from datetime import datetime
// MAGIC     timeformat1="%Y-%m-%d %H:%M:%S" # "yyyy-mm-dd HH:mm:ss" 
// MAGIC     end = datetime.strptime(end_date, timeformat1)
// MAGIC     start = datetime.strptime(start_date, timeformat1)
// MAGIC     delta = (end-start).total_seconds()
// MAGIC     days  = divmod(delta, 86400)[0] 
// MAGIC     return days
// MAGIC 
// MAGIC # register as a UDF 
// MAGIC timeDiff_udf = udf(dateDiff, DoubleType())
// MAGIC #
// MAGIC #
// MAGIC df22=df2\
// MAGIC .withColumn("duration_ndays", timeDiff_udf(col("end_date"),col("start_date")))
// MAGIC #
// MAGIC df22.printSchema()
// MAGIC df22.take(5)
// MAGIC #
// MAGIC #df2.unpersist()

// COMMAND ----------

// MAGIC %md
// MAGIC ###Machine Learning
// MAGIC 
// MAGIC The following examples involve using MLlib algorithms

// COMMAND ----------

// MAGIC %md #### **Question 1:** Demonstrate The Use of a MLlib Algorithm Using the DataFrame Interface(`org.apache.spark.ml`).
// MAGIC 
// MAGIC Demonstrate use of an MLlib algorithm and show an example of tuning the algorithm to improve prediction accuracy.

// COMMAND ----------

// MAGIC %python
// MAGIC ##
// MAGIC ##
// MAGIC ##
// MAGIC ## . . . . . . .  P. S. :  I didn't had a lot of time to finish this solution ,  was able to transcript here some of my solutions, in the 10-12.hours took me to complete this exercise.
// MAGIC ##
// MAGIC ##
// MAGIC ##// This is a resolution of an use case I have done for Web Log Classification, with Support of Ngrams , PCA , labeling and for subsequent loading and best model discover.
// MAGIC ##//
// MAGIC ##// In the real world , phew use only SparkML for modeling , In my day-to-day basis I have started using H2O.ai , so I focus in showing a use case I use everyday.
// MAGIC ##//
// MAGIC ##// Here is my pySpark(Cloudera+Anaconda_5.1) with model built in SparkML + H2o.ai for your Appreciation
// MAGIC ##//
// MAGIC ##// Follow my gitGub here : https://github.com/jpacerqueira/Akamai-log-Analysis-SparkML-H2o
// MAGIC ##// 1.) Python : Pyspark + Pandas + H2o :: Modeling 
// MAGIC ##//  https://github.com/jpacerqueira/Akamai-log-Analysis-SparkML-H2o/blob/master/dazn_ott/logs-archive-production/fraud-canada-tokenizedwords/fraud_analysis/Notebooks/warmUp_h2o_cluster.ipynb
// MAGIC ##//
// MAGIC ##//  3.) Execution Pipeline - on a dailibasis
// MAGIC ##### 0. -Execution Pipeline-  
// MAGIC 
// MAGIC ##### 1. https://github.com/jpacerqueira/Akamai-log-Analysis-SparkML-H2o/blob/master/dazn_ott/logs-archive-production/fraud-canada-tokenizedwords/fraud_analysis/Notebooks/x1-FraudCanada-Model-NGrams-CountVectorizer-KL-KS-Entropy-Model-CleanData.py
// MAGIC ##### 2. https://github.com/jpacerqueira/Akamai-log-Analysis-SparkML-H2o/blob/master/dazn_ott/logs-archive-production/fraud-canada-tokenizedwords/fraud_analysis/Notebooks/x2-FraudCanada-Model-NGrams-CountVectorizer-KL-KS-Entropy-Model-Labeling.py
// MAGIC ##### 3. https://github.com/jpacerqueira/Akamai-log-Analysis-SparkML-H2o/blob/master/dazn_ott/logs-archive-production/fraud-canada-tokenizedwords/fraud_analysis/Notebooks/x3-FraudCanada-AUTOML-Model-NGrams-CountVectorizer-KL-KS-Entropy.py
// MAGIC ##### 4. https://github.com/jpacerqueira/Akamai-log-Analysis-SparkML-H2o/blob/master/dazn_ott/logs-archive-production/fraud-canada-tokenizedwords/fraud_analysis/Notebooks/x4-FraudCanada-Merge-Scoring-Data-From-Model.py
// MAGIC ##### 5. https://github.com/jpacerqueira/Akamai-log-Analysis-SparkML-H2o/blob/master/dazn_ott/logs-archive-production/fraud-canada-tokenizedwords/fraud_analysis/Notebooks/x5-search-discover-values-hash_message.py
// MAGIC ###
// MAGIC ##
// MAGIC ##
// MAGIC ####   My Demonstration . From here is the code of daily process : Clean-Up of WebLogs and Modeling Labeling using NGram and PCA from SparkML
// MAGIC ##
// MAGIC ##
// MAGIC ######################   Required in Cloudera Anaconda Notebook
// MAGIC #import findspark
// MAGIC #findspark.init()
// MAGIC ######################
// MAGIC #
// MAGIC import pyspark
// MAGIC from pyspark.sql import functions as pfunc
// MAGIC from pyspark.sql import SQLContext
// MAGIC from pyspark.sql import Window, types
// MAGIC #
// MAGIC import re
// MAGIC import pandas as pd
// MAGIC import numpy as np
// MAGIC from pandas import DataFrame
// MAGIC from pyspark.sql.types import IntegerType
// MAGIC from pyspark.sql.types import FloatType
// MAGIC from pyspark.sql.functions import udf
// MAGIC from pyspark.sql.functions import *
// MAGIC from pyspark.sql.types import StringType
// MAGIC from scipy.stats import kstest
// MAGIC from scipy import stats
// MAGIC #
// MAGIC from pyspark.ml.feature import Tokenizer
// MAGIC from pyspark.ml.feature import RegexTokenizer
// MAGIC #
// MAGIC #import org.apache.spark.ml.feature.NGram
// MAGIC from pyspark.ml.feature import NGram
// MAGIC #
// MAGIC from collections import Counter
// MAGIC #
// MAGIC from pyspark.ml.feature import NGram
// MAGIC #
// MAGIC from pyspark.ml.feature import NGram, CountVectorizer, VectorAssembler
// MAGIC from pyspark.ml import Pipeline
// MAGIC #
// MAGIC from pyspark.mllib.linalg import SparseVector, DenseVector
// MAGIC #
// MAGIC from pyspark.ml.feature import PCA
// MAGIC from pyspark.ml.linalg import Vectors
// MAGIC #
// MAGIC ######################   Required in Cloudera Anaconda Notebook
// MAGIC #
// MAGIC ####sc = pyspark.SparkContext(appName="FraudCanada-Model-NGrams-CountVectorizer-KL-KS-Entropy-Model-CleanData")
// MAGIC ####sqlContext = SQLContext(sc)
// MAGIC ########
// MAGIC #
// MAGIC # Arguments
// MAGIC #
// MAGIC #
// MAGIC ######################   Required in Cloudera Anaconda Notebook
// MAGIC #
// MAGIC #import argparse
// MAGIC ## Parse date_of execution
// MAGIC #parser = argparse.ArgumentParser()
// MAGIC #parser.add_argument("--datev1", help="Execution Date")
// MAGIC #parser.add_argument("--fraudnrdaily", help="Fraud Records Found")
// MAGIC #args = parser.parse_args()
// MAGIC #if args.datev1:
// MAGIC #    processdate = args.datev1
// MAGIC #    
// MAGIC # GENERAL PREPARATION SCRIPT
// MAGIC #  Date in format YYYYMMDD
// MAGIC #process_date = processdate
// MAGIC #if not process_date:
// MAGIC #    process_date = "20190122"
// MAGIC #
// MAGIC process_date="20190122"
// MAGIC #
// MAGIC #
// MAGIC ######################   Required in Cloudera Anaconda Notebook
// MAGIC #
// MAGIC #if args.fraudnrdaily:
// MAGIC #    fraud_number_records_daily = args.fraudnrdaily
// MAGIC #if not fraud_number_records_daily:
// MAGIC #    fraud_number_records_daily = "0"
// MAGIC fraud_number_records_daily = "0"
// MAGIC #
// MAGIC #
// MAGIC print("fraud_number_records_daily="+fraud_number_records_daily)
// MAGIC #
// MAGIC #
// MAGIC # Pick only Expand Files from x.2019
// MAGIC ## Pick all Additional 2019 Fraud patterns YYYMMMDD.JSON files 
// MAGIC input_file1_playback_fraud="hdfs:///data/staged/ott_dazn/fraud-canada-tokenizedwords/dt=*/*.json"
// MAGIC #
// MAGIC output_file1="hdfs:///data/staged/ott_dazn/advanced-model-data/fraud-notfraud-canada-tokenizedwords-ngrams-7-features-85/dt="+process_date
// MAGIC #
// MAGIC input_file2_playback_not_fraud="hdfs:///data/staged/ott_dazn/logs-archive-production/parquet/dt="+process_date+"/*.parquet"
// MAGIC output_file2="hdfs:///data/staged/ott_dazn/advanced-model-data/not-fraud-canada-tokenizedwords/dt="+process_date
// MAGIC input_file3=output_file2
// MAGIC #
// MAGIC input_file4="hdfs:///data/staged/ott_dazn/advanced-model-data/fraud-notfraud-canada-tokenizedwords-ngrams-7-features-85/dt="+process_date+"/*.*"
// MAGIC #
// MAGIC output_most_frequent_fraud_df="hdfs:///data/staged/ott_dazn/advanced-model-data/the-most-frequent-fraud-hash_message/dt="+process_date
// MAGIC #
// MAGIC output_most_frequent_notfraud_df="hdfs:///data/staged/ott_dazn/advanced-model-data/the-most-frequent-notfraud-hash_message/dt="+process_date
// MAGIC #
// MAGIC ##### AUX. Functions
// MAGIC #
// MAGIC # Last 8 tokes identifies ViwerID, DeviceID and User Status
// MAGIC #
// MAGIC def last_8_tokens(words):
// MAGIC     return ''.join(words[-8:])
// MAGIC #       
// MAGIC last_8_tokens_udf = udf(last_8_tokens, StringType())  
// MAGIC #
// MAGIC # DeviceID via 3 tokens
// MAGIC #
// MAGIC def match_deviceid_3_tokens(words):
// MAGIC     return ''.join(words[-5:-3])
// MAGIC #       
// MAGIC match_deviceid_3_tokens_udf = udf(match_deviceid_3_tokens, StringType())  
// MAGIC # 
// MAGIC #
// MAGIC #####
// MAGIC #  FILTER Non-Fraud AND LABEL
// MAGIC from pyspark.sql import functions as F
// MAGIC #
// MAGIC #
// MAGIC df2= sqlContext.read.parquet(input_file2_playback_not_fraud).repartition(50)
// MAGIC df2.printSchema()
// MAGIC #
// MAGIC df3 = df2.filter(" (message LIKE '%\"Url\":\"https://isl-ca.dazn.com/misl/v2/Playback%') AND (message LIKE '%,\"Response\":{\"StatusCode\":200,\"ReasonPhrase\":\"OK\",%') AND ( ( (message LIKE '%&Format=MPEG-DASH&%' OR message LIKE '%&Format=M3U&%') ) OR (message NOT LIKE '%\"User-Agent\":\"Mozilla/5.0,(Macintosh; Intel Mac OS X 10_12_6),AppleWebKit/605.1.75,(KHTML, like Gecko),Version/11.1.2,Safari/605.1.75\"},%')   )  ")
// MAGIC df3.printSchema()
// MAGIC df4 = df3.withColumn("messagecut", expr("substring(message, locate('|Livesport.WebApi.Controllers.Playback.PlaybackV2Controller|',message)+60 , length(message)-1)"))
// MAGIC #
// MAGIC # val regexTokenizer = new RegexTokenizer().setInputCol("messagecut").setOutputCol("words").setPattern("\\w+|").setGaps(false)
// MAGIC #
// MAGIC regexTokenizer = RegexTokenizer(minTokenLength=1, gaps=False, pattern='\\w+|', inputCol="messagecut", outputCol="words", toLowercase=True)
// MAGIC #
// MAGIC tokenized = regexTokenizer.transform(df4)\
// MAGIC .filter("message IS NOT NULL").filter("words IS NOT NULL")\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC tokenized.printSchema()
// MAGIC #
// MAGIC #  Exclude from NotFraud all recordds from ViwerID in Fraud source
// MAGIC if ((fraud_number_records_daily == "0")|(fraud_number_records_daily == "")):
// MAGIC     print("No join()")
// MAGIC     tokenized_validated = tokenized.drop(col('match_deviceid_3_tokens')).orderBy(rand()).limit(95000)
// MAGIC     tokenized_validated.printSchema()
// MAGIC else:
// MAGIC     print("Yes join()")
// MAGIC     input_file1="hdfs:///data/staged/ott_dazn/fraud-canada-tokenizedwords/dt="+process_date
// MAGIC     #
// MAGIC     df1=sqlContext.read.json(input_file1).repartition(50)
// MAGIC     tokens_to_match=df1.filter("message IS NOT NULL").filter("words IS NOT NULL")\
// MAGIC     .withColumn('match_deviceid_3_tokens',match_deviceid_3_tokens_udf(col('words')))\
// MAGIC     .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC     # Left outer so notfraud excludes all records from viwerID of Fruad in it's not-fraud dataset
// MAGIC     tokenizedit=tokenized.withColumn('match_deviceid_3_tokens',match_deviceid_3_tokens_udf(col('words')))
// MAGIC     #
// MAGIC     new_expand_match=tokenizedit.join(tokens_to_match, tokenizedit.match_deviceid_3_tokens == tokens_to_match.match_deviceid_3_tokens , 'left_outer').select(tokenizedit.metadata, tokenizedit.logzio_id, tokenizedit.beat, tokenizedit.host, tokenizedit.it, tokenizedit.logzio_codec, tokenizedit.message, tokenizedit.offset, tokenizedit.source, tokenizedit.tags, tokenizedit.type, tokenizedit.messagecut , tokenizedit.words )
// MAGIC     tokenized_validated = new_expand_match.orderBy(rand()).limit(95000)
// MAGIC     tokenized_validated.printSchema()
// MAGIC #
// MAGIC tokenized_validated.coalesce(1).write.json(output_file2)
// MAGIC # Tokenize NON-Fraud-LABEL
// MAGIC # hash the message de-duplicate those records
// MAGIC notfraud_file=sqlContext.read.json(input_file3).repartition(50)
// MAGIC notfraud_file.printSchema()
// MAGIC #
// MAGIC notfraud_df=notfraud_file\
// MAGIC .filter("message IS NOT NULL").filter("words IS NOT NULL")\
// MAGIC .withColumn('fraud_label',lit(0).cast('int'))\
// MAGIC .withColumn('hash_message',F.sha2(col('message'),512)).groupby(col('hash_message'))\
// MAGIC .agg(F.first(col('fraud_label')).alias('fraud_label'),F.first(col('words')).alias('words'),F.first(col('message')).alias('message'))\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC notfraud_df.printSchema()
// MAGIC # Only the Not-Fraud are randomly sorted
// MAGIC #
// MAGIC from pyspark.sql.functions import rand
// MAGIC #
// MAGIC df_notfraud_words = notfraud_df.filter("message IS NOT NULL").select(col('fraud_label'),col('hash_message'),col('words'))\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC df_notfraud_words.printSchema()
// MAGIC #
// MAGIC # FILTER FRAUD AND LABEL 
// MAGIC # Join with Internal Curation Data in urltopredict staged folder
// MAGIC # hash the message de-duplicate those records
// MAGIC fraud_file=sqlContext.read.json(input_file1_playback_fraud).repartition(50)
// MAGIC fraud_file.printSchema()
// MAGIC #
// MAGIC fraud_df=fraud_file\
// MAGIC .filter("message IS NOT NULL").filter("words IS NOT NULL")\
// MAGIC .withColumn('fraud_label',lit(1).cast('int'))\
// MAGIC .withColumn('hash_message',F.sha2(col('message'),512)).groupby(col('hash_message'))\
// MAGIC .agg(F.first(col('fraud_label')).alias('fraud_label'),F.first(col('words')).alias('words'),F.first(col('message')).alias('message'))\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC fraud_df.printSchema()
// MAGIC #
// MAGIC df_words = fraud_df.filter("message IS NOT NULL").select(col('fraud_label'),col('hash_message'),col('words'))\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC df_words.printSchema()
// MAGIC #
// MAGIC # Limit to 100000 Daily Not-Fraud Records input in the nGrams Graph analysis
// MAGIC # As the limit of Ngrams _7 vectors is 264k "ngramscounts_7":{"type":0,"size":262144 ....
// MAGIC #
// MAGIC result_fraud_nofraud_words = df_words.union(df_notfraud_words).limit(100000)\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_SER)
// MAGIC ## Register Generic Functions
// MAGIC # -----------------------------------------------------------------------------
// MAGIC # Build ngrams 75 90 n=6 
// MAGIC # support : https://stackoverflow.com/questions/51473703/pyspark-ml-ngrams-countvectorizer-sorted-based-on-count-weights
// MAGIC # -----------------------------------------------------------------------------
// MAGIC def build_ngrams_part(inputCol="words", n=6):
// MAGIC     ngrams = [ 
// MAGIC         NGram(n=i, inputCol="words", outputCol="ngrams_{0}".format(i)) 
// MAGIC         for i in range(7, n + 1) ]
// MAGIC     vectorizers = [ 
// MAGIC         CountVectorizer(inputCol="ngrams_{0}".format(i), outputCol="ngramscounts_{0}".format(i)) 
// MAGIC         for i in range(7, n + 1) ]
// MAGIC     return Pipeline(stages=ngrams + vectorizers)
// MAGIC #    assembler = [VectorAssembler( inputCols=["ngramscounts_{0}".format(i) for i in range(1, n + 1)], outputCol="features" )]
// MAGIC #    return Pipeline(stages=ngrams + DenseVector(SparseVector(vectorizers).toArray()))
// MAGIC #
// MAGIC # 
// MAGIC # -----------------------------------------------------------------------------
// MAGIC #ngram = build_ngrams_part().fit(df_words)
// MAGIC #ngramDataFrame = ngram.transform(df_words)
// MAGIC #ngramDataFrame.coalesce(1).write.json(output_file1)
// MAGIC #
// MAGIC ngram = NGram(n=7, inputCol="words", outputCol="ngrams_7")
// MAGIC countvector = CountVectorizer(inputCol="ngrams_7", outputCol="ngramscounts_7")
// MAGIC # fit a CountVectorizerModel from the corpus.
// MAGIC countvModel = CountVectorizer(inputCol="words", outputCol="features_85", vocabSize=85, minDF=2.0)
// MAGIC # fit a PCA Dimensionality reduction into 7/3=2.x components from ngramscounts_7 ## Too Heavy 1st PCA
// MAGIC pcaNgrams = PCA(k=3, inputCol="ngramscounts_7", outputCol="pcaweightngrams")
// MAGIC # fit a PCA Dimensionality reduction into 85/17=5 components from words
// MAGIC pcaWords = PCA(k=5, inputCol="features_85", outputCol="pcaweightwords")  ## Too Heavy 2nd PCA
// MAGIC #
// MAGIC ngram_fraud_DF = ngram.transform(result_fraud_nofraud_words)
// MAGIC ngram_vc_fraud_DF = countvector.fit(ngram_fraud_DF).transform(ngram_fraud_DF)\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC ngram_vc_fraud_DF.printSchema()
// MAGIC #
// MAGIC # Trial of PCA now with Less Data
// MAGIC #modelPCA_ngram_fraud_DF = pcaNgrams.fit(ngram_vc_fraud_DF).transform(ngram_vc_fraud_DF)\
// MAGIC #.persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC #modelPCA_ngram_fraud_DF.printSchema()
// MAGIC ##
// MAGIC ############# ISSUE - NGRAMS ARE TOO BIG ############
// MAGIC #Traceback (most recent call last):
// MAGIC #  File "/opt/cloudera/parcels/SPARK2-2.3.0.cloudera2-1.cdh5.13.3.p0.316101/lib/spark2/python/pyspark/sql/utils.py", line 63, in deco
// MAGIC #    return f(*a, **kw)
// MAGIC #  File "/opt/cloudera/parcels/SPARK2-2.3.0.cloudera2-1.cdh5.13.3.p0.316101/lib/spark2/python/lib/py4j-0.10.6-src.zip/py4j/protocol.py", line 320, in get_return_value
// MAGIC #py4j.protocol.Py4JJavaError: An error occurred while calling o200.fit.
// MAGIC #: java.lang.IllegalArgumentException: Argument with more than 65535 cols: 262144
// MAGIC #	at org.apache.spark.mllib.linalg.distributed.RowMatrix.checkNumColumns(RowMatrix.scala:133)
// MAGIC #	at org.apache.spark.mllib.linalg.distributed.RowMatrix.computeCovariance(RowMatrix.scala:332)
// MAGIC #	at org.apache.spark.mllib.linalg.distributed.RowMatrix.computePrincipalComponentsAndExplainedVariance(RowMatrix.scala:387)
// MAGIC #	at org.apache.spark.mllib.feature.PCA.fit(PCA.scala:53)
// MAGIC #	at org.apache.spark.ml.feature.PCA.fit(PCA.scala:99)
// MAGIC #	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
// MAGIC #	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
// MAGIC #	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
// MAGIC #	at java.lang.reflect.Method.invoke(Method.java:498)
// MAGIC #	at py4j.reflection.MethodInvoker.invoke(MethodInvoker.java:244)
// MAGIC #	at py4j.reflection.ReflectionEngine.invoke(ReflectionEngine.java:357)
// MAGIC #	at py4j.Gateway.invoke(Gateway.java:282)
// MAGIC #	at py4j.commands.AbstractCommand.invokeMethod(AbstractCommand.java:132)
// MAGIC #	at py4j.commands.CallCommand.execute(CallCommand.java:79)
// MAGIC #	at py4j.GatewayConnection.run(GatewayConnection.java:214)
// MAGIC #	at java.lang.Thread.run(Thread.java:748)
// MAGIC #
// MAGIC #
// MAGIC #During handling of the above exception, another exception occurred:
// MAGIC #
// MAGIC #Traceback (most recent call last):
// MAGIC #  File "/home/siemanalyst/projects/logs-archive-production/fraud-canada-tokenizedwords/notebooks/x1-FraudCanada-Model-NGrams-CountVectorizer-KL-KS-Entropy-Model-CleanData.py", line 173, in <module>
// MAGIC #####################################################
// MAGIC #
// MAGIC #result_ngrams_words_fraud_DF = countvModel.fit(modelPCA_ngram_fraud_DF).transform(modelPCA_ngram_fraud_DF)\
// MAGIC result_ngrams_words_fraud_DF = countvModel.fit(ngram_vc_fraud_DF).transform(ngram_vc_fraud_DF)\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC result_ngrams_words_fraud_DF.printSchema()
// MAGIC #
// MAGIC #modelPCA_features_ngram_fraud_DF = pcaWords.fit(result_ngrams_words_fraud_DF).transform(result_ngrams_words_fraud_DF)\
// MAGIC #.persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC #modelPCA_features_ngram_fraud_DF.printSchema()
// MAGIC #
// MAGIC #modelPCA_features_ngram_fraud_DF.coalesce(1).write.json(output_file1)
// MAGIC result_ngrams_words_fraud_DF.coalesce(1).write.json(output_file1)
// MAGIC #
// MAGIC print("Calculation of most frequent fraud_ngram notfraud_ngram - Start!")
// MAGIC #
// MAGIC #  CALCULATE KL,KS COEF. Label Data fraud/not_fraud
// MAGIC ###################
// MAGIC # Obtain the most frequent word on each position 
// MAGIC # Compose the standard_fraud_ngram from the most common positions
// MAGIC # Calculate the standard_fraud_ngram
// MAGIC #
// MAGIC # https://stackoverflow.com/questions/35218882/find-maximum-row-per-group-in-spark-dataframe 
// MAGIC # Using struct ordering:
// MAGIC #from pyspark.sql.functions import struct
// MAGIC #
// MAGIC #(cnts
// MAGIC #  .groupBy("id_sa")
// MAGIC #  .agg(F.max(struct(col("cnt"), col("id_sb"))).alias("max"))
// MAGIC #  .select(col("id_sa"), col("max.id_sb")))
// MAGIC #
// MAGIC ####################
// MAGIC # FRAUD
// MAGIC ngram7_fraud=sqlContext.read.json(input_file4).filter("fraud_label=1")
// MAGIC ngram7_fraud.printSchema()
// MAGIC #
// MAGIC most_frequent_fraud_df=ngram7_fraud\
// MAGIC .withColumn("value_sum",F.explode("ngramscounts_7.values"))\
// MAGIC .groupBy("hash_message").agg(F.sum("value_sum").alias('count'))\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC most_frequent_fraud_df.printSchema()
// MAGIC #
// MAGIC most_frequent_fraud_df.coalesce(1).write.json(output_most_frequent_fraud_df)
// MAGIC #
// MAGIC # The most Frequent would the the max
// MAGIC standard_fraud_ngram=most_frequent_fraud_df.orderBy(col('count').desc()).select(col('hash_message')).limit(1).toPandas()
// MAGIC #
// MAGIC print("Value Print: standard_fraud_ngram=")
// MAGIC print(standard_fraud_ngram)
// MAGIC #
// MAGIC ####################
// MAGIC # NOT FRAUD
// MAGIC ngram7_notfraud=sqlContext.read.json(input_file4).filter("fraud_label=0")
// MAGIC ngram7_notfraud.printSchema()
// MAGIC #
// MAGIC most_frequent_notfraud_df=ngram7_notfraud\
// MAGIC .withColumn("value_sum",F.explode("ngramscounts_7.values"))\
// MAGIC .groupBy("hash_message").agg(F.sum("value_sum").alias('count'))\
// MAGIC .persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
// MAGIC most_frequent_notfraud_df.printSchema()
// MAGIC #
// MAGIC most_frequent_notfraud_df.coalesce(1).write.json(output_most_frequent_notfraud_df)
// MAGIC #
// MAGIC # The most Frequent would the the max
// MAGIC standard_notfraud_ngram=most_frequent_notfraud_df.orderBy(col('count').desc()).select(col('hash_message')).limit(1).toPandas()
// MAGIC #
// MAGIC print("Value Print: standard_notfraud_ngram=")
// MAGIC print(standard_notfraud_ngram)
// MAGIC #
// MAGIC print("Calculation of most frequent fraud_ngram notfraud_ngram - Done!")
// MAGIC #
// MAGIC sc.stop()
// MAGIC #
// MAGIC print("Preparation of Data Done!")
// MAGIC #
// MAGIC #
