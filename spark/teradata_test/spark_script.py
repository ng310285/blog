import sys
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


# Process the data that the query supplies
line = sys.stdin.readline()
while line:
    line_list = line.split('\t')
    query_id = str(line_list[0])
    # Remove any new line characters for spark processing
    query_text = str(line_list[1]).replace('\n', ' ').replace('\r', '')

    output = {'query': query_text}
    print("%s\t%s" % (query_id, output))

