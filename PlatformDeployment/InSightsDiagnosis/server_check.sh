#!/bin/bash
echo "TimeStamp -> " $(date '+%F %T')""   >> ServerConfigReport.log
SERVER_CONFIG_PATH=$INSIGHTS_HOME/.InSights/server-config.json

echo '{"foo":"bar"}' | python -m json.tool $SERVER_CONFIG_PATH >> /dev/null && echo "Valid JSON" || echo "NOT valid JSON"  >> ServerConfigReport.log

ES_URL=$(cat $SERVER_CONFIG_PATH|jq -r '.endpointData.elasticSearchEndpoint')
NEO4J_URL=$(cat $SERVER_CONFIG_PATH|jq -r '.graph.endpoint')
NEO4J_AUTH_TOKEN=$(cat $SERVER_CONFIG_PATH|jq -r '.graph.authToken')
GRAFANA_URL=$(cat $SERVER_CONFIG_PATH|jq -r '.grafana.grafanaEndpoint')
GRAFANA_USER_NAME=$(cat $SERVER_CONFIG_PATH|jq -r '.grafana.adminUserName')
GRAFANA_PASSWORD=$(cat $SERVER_CONFIG_PATH|jq -r '.grafana.adminUserPassword')
DOCROOT_URL=$(cat $SERVER_CONFIG_PATH|jq -r '.agentDetails.docrootUrl')
DOCROOT_REGISTER=$(cat $SERVER_CONFIG_PATH|jq -r '.agentDetails.isOnlineRegistration')
echo "ELASTICSEARCH : "$ES_URL >> ServerConfigReport.log
curl -s $ES_URL > /dev/null
res=$?
if test "$res" != "0";
then
   echo "	Could not reach Elastic Search URL" >> ServerConfigReport.log
else
   echo "	Valid Elastic Search URL" >> ServerConfigReport.log
fi
echo "NEO4J : "$NEO4J_URL >> ServerConfigReport.log
curl -s $NEO4J_URL > /dev/null
res=$?
if test "$res" != "0";
then
   echo "	Could not reach Neo4j URL" >> ServerConfigReport.log
else
   echo "	Valid Neo4j URL" >> ServerConfigReport.log
fi
echo "GRAFANA : "$GRAFANA_URL  >> ServerConfigReport.log
echo $GRAFANA_USER_NAME  >> ServerConfigReport.log
echo $GRAFANA_PASSWORD  >> ServerConfigReport.log
curl -s $GRAFANA_URL > /dev/null
res=$?
if test "$res" != "0";
then
   echo "	Could not reach Grafana URL"  >> ServerConfigReport.log
else
   grafana_password_check=$(curl -X GET -u ${GRAFANA_USER_NAME}:${GRAFANA_PASSWORD} ${GRAFANA_URL}/api/admin/settings)
   if [[ $grafana_password_check = *"Invalid"* ]]; then
       echo "		Incorrect user and password."  >> ServerConfigReport.log
   else
       echo "		User and password from grafana is working."  >> ServerConfigReport.log
   fi
   echo "	Valid Grafana URL"  >> ServerConfigReport.log
fi

echo "DOCROOT : "$DOCROOT_URL   >> ServerConfigReport.log
echo $DOCROOT_REGISTER >> ServerConfigReport.log
curl -s $DOCROOT_URL > /dev/null
res=$?
if test "$res" != "0";
then
   echo "	Could not reach Docroot URL"  >> ServerConfigReport.log
else
   echo "	Valid Docroot URL"  >> ServerConfigReport.log
fi
