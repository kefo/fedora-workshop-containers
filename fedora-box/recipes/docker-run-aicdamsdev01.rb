
# This file is run when docker container is started.
file "/tmp/start.sh" do
  # Specify permissions here
  owner "root"
  group "root"
  mode "0755"
  
  # Multi-line content - note, content will have leading whitespace
  content <<-EOF
    #!/bin/sh
    # su - postgres -c "/usr/bin/postgres -D /var/lib/pgsql/data" &
    service postgresql-9.4 start
    service tomcat_7 start
    echo "Pausing for 30 seconds (because fcrepo needs time to start)..."
    sleep 30
    # This curl command should force fcrepo to instantiate its log file.
    curl -X GET -i http://localhost:8080/fcrepo/rest/
    curl -X PUT -i http://localhost:8080/fcrepo/rest/prod
    curl -X PUT -i http://localhost:8080/fcrepo/rest/test
    curl -X PUT -i http://localhost:8080/fcrepo/rest/dev
    # tail -f /opt/tomcat_7/logs/catalina.out 
    sleep 1
    tail -F /data/fcrepo/logs/fcrepo.log
  EOF
end