DELETE DATABASE spark;
DROP DATABASE spark;
CREATE DATABASE spark FROM DBC AS perm=1e9;

DATABASE spark;
GRANT ALL ON spark TO dbc;

CALL sysuif.replace_file('spark_script', 'spark_script.py', 'sz!/root/blog-master/spark/spark_script.py', 0);

SHOW FILE spark.spark_script;

SET SESSION SEARCHUIFDBPATH = spark;

drop table  spark.query_ngrams;

-- Make sure there are rows in DBC.QryLogSQL
SELECT COUNT(*)
FROM DBC.QryLogSQL
;

CREATE TABLE spark.query_ngrams AS (
SELECT    tab.QueryID
        , CAST(tab.json_text AS JSON) AS ngrams
FROM SCRIPT (
    ON (
                SELECT   TOP 100 QueryId
                       , SqlTextInfo
                FROM DBC.QryLogSQL
       ) HASH BY QueryID 
       SCRIPT_COMMAND('python ./spark/spark_script.py')
       RETURNS ('QueryID VARCHAR(30)',  'json_text CLOB')
    ) AS tab
) WITH DATA
PRIMARY INDEX (QueryID)
;
                            
SELECT COUNT(ngrams)
FROM spark.query_ngrams
;

SELECT QueryID, ngrams (VARCHAR(2000))
FROM spark.query_ngrams
;				
