#!/bin/sh

service postgresql-9.4 start
echo "Pausing for 15 seconds (because postgres needs time to start)..."
sleep 15

service tomcat_7 start
echo "Pausing for 30 seconds (because fcrepo needs time to start)..."
sleep 30

# This curl command should force fcrepo to instantiate its log file.
curl -X GET -i http://<%= node[:tomcat][:host_alias] %>:8080/fcrepo/rest/
curl -X PUT -i http://<%= node[:tomcat][:host_alias] %>:8080/fcrepo/rest/prod
curl -X PUT -i http://<%= node[:tomcat][:host_alias] %>:8080/fcrepo/rest/test
curl -X PUT -i http://<%= node[:tomcat][:host_alias] %>:8080/fcrepo/rest/dev

tail -F /data/fcrepo/logs/fcrepo.log