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
echo "Grafana Health Check started "  >> Grafana_health.txt

HOST=localhost
PORT=3000
USER='admin'
PASSWORD='admin'

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
fi
if [ ! -z "$1" ]; then HOST="$1"; fi
if [ ! -z "$2" ]; then PORT="$2"; fi
if [ ! -z "$3" ]; then USER="$3"; fi
if [ ! -z "$4" ]; then PASSWORD="$4"; fi

echo "***** Script run  at " $(date '+%F %T')"*****"   >> Grafana_health.txt
echo "Host "$HOST" PORT "$PORT  "USER " $USER >> Grafana_health.txt

servicestatus="1"
contenttype="Content-Type:application/json"
accept="Accept:application/json"

curl_check=$(curl -u $USER:$PASSWORD http://$HOST:$PORT --write-out %{http_code} --silent --output /dev/null )

echo " Response of curl command is : "  $curl_check >> Grafana_health.txt

curl_basic="curl -u $USER:$PASSWORD GET  --silent --write-out %{http_code} --output /dev/null  "

if [ $curl_check -eq 200 ]; then
  echo "	Grafana is installed and Running fine" >> Grafana_health.txt
  echo "	Grafana curl is working " >> Grafana_health.txt
  echo "API call for Grafana " >> Grafana_health.txt

  grafana_user_details=$($curl_basic "http://$HOST:$PORT/api/users" )
  echo "	Grafana users detail : ">> Grafana_health.txt
  echo "		"$grafana_user_details >> Grafana_health.txt
  
  organization_current_user=$($curl_basic "http://$HOST:$PORT/api/user/orgs")
  echo "	current user organization are : ">> Grafana_health.txt
  echo "		"$organization_current_user >> Grafana_health.txt
  
  dashboard_details=$($curl_basic "http://$HOST:$PORT/api/search" ) 
  echo "	Dashboard Details are : ">> Grafana_health.txt
  echo "		"$dashboard_details >> Grafana_health.txt
  
  datasouce_details=$($curl_basic "http://$HOST:$PORT/api/datasources" )
  echo "	Data source details are : ">> Grafana_health.txt
  echo "		"$datasouce_details >> Grafana_health.txt
  
else
  echo "	Grafana is not installed or not Running as service "  >> Grafana_health.txt
  echo "	Grafana curl command is not working,Please check your hostname and username" >> Grafana_health.txt
  
fi

echo "Usage: grafanaCheck.sh Host Port User Password "