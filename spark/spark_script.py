#import sys
import os
import resource
import faulthandler
faulthandler.enable()

for param in os.environ.keys():
    os.write(2, str("%20s %s\n" % (param,os.environ[param])).encode())

import requests
import json
import textwrap
import time
host = 'http://192.168.116.128:8998'
data = {'kind': 'spark'}
headers = {'Content-Type': 'application/json'}

os.write(2,"a\n".encode())
# Startup a session
r = requests.post(host + '/sessions', data=json.dumps(data), headers=headers)
os.write(2,"a\n".encode())
session_url = host + r.headers['location']
os.write(2,"a\n".encode())
r = requests.get(session_url, headers=headers)
os.write(2,"a\n".encode())
session_id = r.json()['id']

os.write(2,"a\n".encode())
# Wait until the session has started
while r.json()['state'] == 'starting':
    time.sleep(1)
    r = requests.get(session_url, headers=headers)

statements_url = session_url + '/statements'

# Process the data that the query supplies
line = sys.stdin.readline()
while line:
    line_list = line.split('\t')
    query_id = str(line_list[0])
    # Remove any new line characters for spark processing
    query_text = str(line_list[1]).replace('\n', ' ').replace('\r', '')

    spark_code = str("""
        import org.apache.spark.ml.feature.{RegexTokenizer, Tokenizer, NGram}
        import org.apache.spark.sql.SQLContext
        import org.apache.spark.{SparkConf, SparkContext}
    
        val sqlContext = new SQLContext(sc)
        val sentenceDataFrame = sqlContext.createDataFrame(Seq(
          (0, "%s")
        )).toDF("id", "sentence")
        
        val tokenizer = new Tokenizer().setInputCol("sentence").setOutputCol("words")
        val tokenized = tokenizer.transform(sentenceDataFrame)
        
        val ngram = new NGram().setN(2).setInputCol("words").setOutputCol("ngrams")
        val ngramDataFrame = ngram.transform(tokenized)
        ngramDataFrame.take(3).map(_.getAs[Stream[String]]("ngrams").toList).foreach(println)
        """ % query_text)
    data = {
       'code': textwrap.dedent(spark_code)
    }
    r = requests.post(statements_url, data=json.dumps(data), headers=headers)
    code_session_url = host + r.headers['location']
    r = requests.get(session_url, headers=headers)

    # Poll the url until processing is complete
    while r.json()['state'] == 'running' or r.json()['state'] == 'busy':
        time.sleep(1)
        r = requests.get(code_session_url, headers=headers)
    # Output the results
    r = requests.get(code_session_url, headers=headers)
    print("%s\t%s" % (query_id, str(r.json()['output'])))

    # Get the next line
    line = sys.stdin.readline()

# Wait until the session is available then cleanup
while r.json()['state'] != 'available':
    time.sleep(1)
    r = requests.get(session_url, headers=headers)

session_url = host + '/sessions/' + str(session_id)
requests.delete(session_url, headers=headers)