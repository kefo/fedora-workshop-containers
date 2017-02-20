
# install mongodb
# include_recipe "mongodb::default"

directory '/data' do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end

directory '/data/mongodb' do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end

# Sometimes, it's just easier to install the source.
remote_file "/tmp/mongodb-linux-x86_64-3.2.8.tgz" do
  source "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.2.8.tgz"
  # action :create_if_missing
  action :create
  mode "0644"
end

bash 'extract_module' do
    # mkdir -p /opt/mongodb
    code <<-EOH
        tar xzf /tmp/mongodb-linux-x86_64-3.2.8.tgz -C /tmp/
        mv /tmp/mongodb-linux-x86_64-3.2.8 /opt/mongodb
        EOH
end

