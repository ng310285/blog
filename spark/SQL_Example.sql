DATABASE spark;
GRANT ALL ON spark TO dbc;
-- initial installation of script
CALL sysuif.install_file('spark_script', 'spark_script.py', 'sz!/root/spark/spark_script.py');
-- to replace/update script
CALL sysuif.replace_file('spark_script', 'spark_script.py', 'sz!/root/spark/spark_script.py', 0);

SET SESSION SEARCHUIFDBPATH = spark;

CREATE TABLE spark.query_ngrams AS (
   SELECT    tab.QueryID
           , CAST(tab.json_text AS JSON) AS ngrams
FROM SCRIPT (
    ON (
            SELECT   QueryId
	                 , SqlTextInfo
		        FROM DBC.QryLogSQL
			) PARTITION BY QueryID 
	SCRIPT_COMMAND('source /etc/profile;ulimit -v 1000000;env > /tmp/env_$$.txt;/usr/local/bin/python3 ./spark/spark_script.py')
	RETURNS ('QueryID VARCHAR(30)',  'json_text CLOB')
   ) AS tab
) WITH DATA
PRIMARY INDEX (QueryID)
;
				
