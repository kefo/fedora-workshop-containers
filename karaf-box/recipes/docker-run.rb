
# This file is run when docker container is started.
file "/tmp/start.sh" do
  # Specify permissions here
  owner "root"
  group "root"
  mode "0755"
  # Multi-line content - note, content will have leading whitespace
  content <<-EOF
    #!/bin/sh
    
    echo "Starting karaf"
    /opt/lake/karaf/bin/karaf-service start
    sleep 1
    tail -F /opt/lake/karaf/data/log/karaf.log
    
  EOF
end