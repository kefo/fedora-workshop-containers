include_recipe "fedora-box::tomcat"

%w[ /data /data/fcrepo /data/fcrepo/jms ].each do |path|
  directory path do
    owner 'root'
    group 'tomcat_7'
    mode '0775'
  end
end


%w[ /opt/lake /opt/lake/webapps /opt/lake/webapps/fcrepo ].each do |path|
  directory path do
    owner 'root'
    group 'tomcat_7'
    mode '0775'
  end
end

%w[ /opt/lake/etc /opt/lake/etc/fcrepo ].each do |path|
  directory path do
    owner 'root'
    group 'tomcat_7'
    mode '0775'
  end
end


remote_file "/opt/lake/webapps/fcrepo/fcrepo-webapp-4.7.1.war" do
  # 4.7.1 Final
  source "https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.7.1/fcrepo-webapp-4.7.1.war"
  
  # action :create_if_missing
  action :create
  mode "0644"
end

link "/opt/lake/webapps/fcrepo/fcrepo.war" do
  to "/opt/lake/webapps/fcrepo/fcrepo-webapp-4.7.1.war"
end

# get templated install properties
cookbook_file "/opt/tomcat_7/conf/Catalina/localhost/fcrepo.xml" do
  source 'fcrepo-context.xml'
  owner 'tomcat_7'
  group 'tomcat_7'
  mode '0644'
  action :create
end

template "/opt/lake/etc/fcrepo/repository-fcrepo-4.7.json" do
  source "repository-fcrepo-4.7.json"
  owner 'root'
  group 'tomcat_7'
  mode "0664"
end

directory node[:fedora][:logdir] do
  owner 'root'
  group 'tomcat_7'
  mode '0775'
  action :create
end

file node[:fedora][:logdir] + "/fcrepo.log" do
  content 'Line'
  mode '0664'
  owner 'tomcat_7'
  group 'tomcat_7'
end

template "/opt/lake/etc/fcrepo/logback.xml" do
  source "fcrepo-logback.xml"
  owner 'root'
  group 'tomcat_7'
  mode "0664"
end

