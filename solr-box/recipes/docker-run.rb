
# This file is run when docker container is started.
file "/tmp/start.sh" do
  # Specify permissions here
  owner "root"
  group "root"
  mode "0755"
  # Multi-line content - note, content will have leading whitespace
  content <<-EOF
    #!/bin/sh
    
    echo "Starting solr..."    
    service solr start
    echo "Pausing for 10 seconds (time to start)..."
    sleep 10
    curl -X GET -i "http://192.168.99.100:8983/solr/admin/cores?action=CREATE&name=prodidx&instanceDir=prodidx&config=solrconfig.xml&schema=schema.xml&dataDir=data"
    tail -F /data/solr/logs/solr.log
    
  EOF
end