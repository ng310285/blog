CREATE DATABASE spark FROM DBC AS perm=1e9;

DATABASE spark;
GRANT ALL ON spark TO dbc;

--CALL sysuif.remove_file('spark_script',0);
--CALL sysuif.install_file('spark_script', 'spark_script.py', 'sz!spark_script.py!/root/spark/spark_script.py');
CALL sysuif.replace_file('spark_script', 'spark_script.py', 'sz!/root/spark/spark_script.py', 0);

SHOW FILE spark.spark_script;

SET SESSION SEARCHUIFDBPATH = spark;
				
	CREATE TABLE spark.query_ngrams AS (
    SELECT    tab.QueryID
	                  , CAST(tab.json_text AS JSON) AS ngrams
	FROM SCRIPT (
	    ON (
		            SELECT    QueryId
					                 , SqlTextInfo
			        FROM DBC.QryLogSQL
				) PARTITION BY QueryID 
		SCRIPT_COMMAND('/usr/local/anaconda3/bin/python3 ./spark/spark_script.py')
		RETURNS ('QueryID VARCHAR(30)',  'json_text CLOB')
    ) AS tab
	) WITH DATA
	PRIMARY INDEX (QueryID)
	;
