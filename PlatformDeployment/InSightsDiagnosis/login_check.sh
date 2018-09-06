#-------------------------------------------------------------------------------
#  Copyright 2017 Cognizant Technology Solutions
#  
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not
#  use this file except in compliance with the License.  You may obtain a copy
#  of the License at
#  
#    http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
#  License for the specific language governing permissions and limitations under
#  the License.

#!/bin/sh
TOMCAT_HOME="/opt/apache-tomcat-8.5.27"
myextip=$(wget -qO- icanhazip.com)
curl -s 'http://'"$myextip"':8080/app/#!/InSights/login' > /dev/null
res=$?
if test "$res" != "0";
then
   curl -s 'http://'"$myextip"':8080' > /dev/null
   res=$?
   if test "$res" != "0";
   then
      echo "Tomcat is not running" >> login.log
      err=$(grep 'ERROR' $TOMCAT_HOME/logs/catalina.out|tail -10)
      if [[ -z "$err" ]]; then
         echo "No error found" >> login.log
      else
         echo -e "Error found:\n$err" >> login.log
      fi
   else
      if [ -f "$TOMCAT_HOME/webapps/PlatformService.war" ]
      then
         err=$(grep 'ERROR' $TOMCAT_HOME/logs/catalina.out|tail -10)
         if [[ -z "$err" ]]; then
            echo "No error found" >> login.log
         else
            echo -e "Error found:\n$err" >> login.log
         fi
      else
         echo "PlatformService.war not found." >> login.log
      fi
   fi
else
    echo "PlatformService STATUS CHECK" >> login.log
    echo "TimeStamp : " $(date '+%F %T')""   >> login.log
    echo "IP: ${myextip}, PORT : 8080, User: admin, Password: admin" >> login.log

   curl_command="curl -X POST -u admin:admin --header \"Authorization: Basic YWRtaW46YWRtaW4=\" http://${myextip}:8080/PlatformService/user/authenticate"
   RESPONSE=`$curl_command`

   if [[ $RESPONSE = *"\"status\":\"SUCCESS\""* ]]; then
      echo "        Login is working with $curl_command" >> login.log
   else
      echo "        Login is not working $RESPONSE" >> login.log
   fi

fi

