#!/bin/sh
    
echo "Starting solr..."    
service solr start
echo "Pausing for 20 seconds (time to start)..."
sleep 20

curl -X GET -i "http://<%= node[:solr][:host_alias] %>:8983/solr/admin/cores?action=CREATE&name=prodidx&instanceDir=prodidx&config=solrconfig.xml&schema=schema.xml&dataDir=data"
curl -X GET -i "http://<%= node[:solr][:host_alias] %>:8983/solr/admin/cores?action=CREATE&name=demoidx&instanceDir=demoidx&config=solrconfig.xml&schema=schema.xml&dataDir=data"
tail -F /data/solr/logs/solr.log