CREATE DATABASE spark FROM DBC AS perm=1e9;

DATABASE spark;
GRANT ALL ON spark TO dbc;

CALL sysuif.replace_file('spark_script', 'spark_script.py', 'sz!/root/spark/spark_script.py', 0);

SHOW FILE spark.spark_script;

SET SESSION SEARCHUIFDBPATH = spark;

drop table  spark.query_ngrams;

    CREATE TABLE spark.query_ngrams AS (
    SELECT    tab.QueryID
                      , CAST(tab.json_text AS JSON) AS ngrams
    FROM SCRIPT (
        ON (
                    SELECT    QueryId
                                     , SqlTextInfo
                    FROM DBC.QryLogSQL
                ) HASH BY QueryID 
        SCRIPT_COMMAND('sh --login -c "python ./spark/spark_script.py"')
        RETURNS ('QueryID VARCHAR(30)',  'json_text CLOB')
    ) AS tab
    ) WITH DATA
    PRIMARY INDEX (QueryID)
    ;
                            
SELECT COUNT(ngrams)
FROM spark.query_ngrams
;

				
