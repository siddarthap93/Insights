#!/bin/sh
#-------------------------------------------------------------------------------
# Copyright 2017 Cognizant Technology Solutions
#   
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a copy
# of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.
#-------------------------------------------------------------------------------
echo "Neo4j Health Check started "  >> Neo4j_health.txt

HOST=localhost
PORT=7474
USER='neo4j'
PASSWORD='C0gnizant@1'

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
fi
if [ ! -z "$1" ]; then HOST="$1"; fi
if [ ! -z "$2" ]; then PORT="$2"; fi
if [ ! -z "$3" ]; then USER="$3"; fi
if [ ! -z "$4" ]; then PASSWORD="$4"; fi

echo "***** Script run  at " $(date '+%F %T')"*****"   >> Neo4j_health.txt
echo "Host "$HOST" PORT "$PORT  "USER " $USER >> Neo4j_health.txt

servicestatus="1"
contenttype="Content-Type:application/json"
accept="Accept:application/json"

curl_check=$(curl -u $USER:$PASSWORD http://$HOST:$PORT --write-out %{http_code} --silent --output /dev/null )

echo " Response of curl command is : "  $curl_check >> Neo4j_health.txt

if [ $curl_check -eq 200 ]; then
  echo "	Neo4j is installed and Running fine" >> Neo4j_health.txt
  echo "	Neo4j curl is working " >> Neo4j_health.txt
  echo "API call for Neo4j " >> Neo4j_health.txt
  
  neo4j_user=$('/usr/bin/curl' -u $USER:$PASSWORD -s -S -H $accept  -H $contenttype -d '{"query":"call dbms.security.listUsers()"}' http://$HOST:$PORT/db/data/cypher )  
  echo "	Neo4j User Detail are : "$neo4j_user >> Neo4j_health.txt
  
  neo4j_record=$('/usr/bin/curl' -u $USER:$PASSWORD -s -S -H $accept  -H $contenttype -d '{"query":"MATCH (n) RETURN count(n)"}' http://$HOST:$PORT/db/data/cypher )
  echo "	Neo4j Record record detail : "$neo4j_record >> Neo4j_health.txt

else
  echo "	Neo4j is not installed or not Running as service "  >> Neo4j_health.txt
  echo "	Neo4j curl command is not working,Please check your hostname and username" >> Neo4j_health.txt
  
fi

echo "Usage: neo4jCheck Host Port User Password "

