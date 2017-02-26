
# This file is run when docker container is started.
template "/tmp/start.sh" do
  source "start.sh"

  # Specify permissions here
  owner "root"
  group "root"
  mode "0755"
  
  action :create
end