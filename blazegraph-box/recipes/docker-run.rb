
# This file is run when docker container is started.
file "/tmp/start.sh" do
  # Specify permissions here
  owner "root"
  group "root"
  mode "0755"
  # Multi-line content - note, content will have leading whitespace
  content <<-EOF
    #!/bin/sh
    
    service tomcat_7 start
    echo "Pausing for 30 seconds (because tomcat apps need time to start)..."
    sleep 30
    
    # This curl command should force fcrepo to instantiate its log file.
    tail -F /opt/tomcat_7/logs/catalina.out 

  EOF
end