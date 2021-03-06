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
# install postgresql
echo "#################### Installing Postgres with configs , Databases and Roles ####################"
#sudo yum install http://platform.cogdevops.com/insights_install/installationScripts/latest/RHEL/postgres/pgdg-redhat95-9.5-2.noarch.rpm -y
#sudo yum install postgresql95-server postgresql95-contrib -y
#sudo /usr/pgsql-9.5/bin/postgresql95-setup initdb
#sudo systemctl enable postgresql-9.5.service
#sudo chkconfig postgresql-9.5 on
#sudo wget http://platform.cogdevops.com/insights_install/installationScripts/latest/RHEL/postgres/pg_hba.conf
#sudo cp pg_hba.conf /var/lib/pgsql/9.5/data/pg_hba.conf
#sudo systemctl start  postgresql-9.5.service
#sudo useradd grafana
#sudo usermod --password C0gnizant@1 grafana
#sudo wget http://platform.cogdevops.com/insights_install/installationScripts/latest/RHEL/postgres/dbscript.sql
#sudo chmod +x dbscript.sql
#psql -U postgres -f dbscript.sql
apt install postgresql
wget http://platform.cogdevops.com/insights_install/installationScripts/latest/RHEL/postgres/pg_hba.conf
cp pg_hba.conf /etc/postgresql/9.5/main/
systemctl stop postgresql.service
sleep 15
systemctl start postgresql.service
useradd grafana
usermod --password C0gnizant@1 grafana
wget http://platform.cogdevops.com/insights_install/installationScripts/latest/RHEL/postgres/dbscript.sql
chmod +x dbscript.sql
psql -U postgres -f dbscript.sql

