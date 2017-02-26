#!/bin/sh
    
service tomcat_7 start
echo "Pausing for 30 seconds (because tomcat apps need time to start)..."
sleep 30
    
# This curl command should force fcrepo to instantiate its log file.
tail -F /opt/tomcat_7/logs/catalina.out 
