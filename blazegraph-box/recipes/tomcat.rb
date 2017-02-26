include_recipe 'java'

tomcat_install '7' do
  version '7.0.69'
end

tomcat_service '7' do
  action [:start, :enable]
  env_vars [{ 
        'CATALINA_PID' => '/tmp/tomcat.pid',
        'JAVA_OPTS' => node[:java][:JAVA_OPTS]
  }]
end

directory "/opt/tomcat_7/conf/Catalina/localhost" do
  owner 'tomcat_7'
  group 'tomcat_7'
  mode '0775'
  recursive true
end

# get templated install properties
template "/opt/tomcat_7/conf/tomcat-users.xml" do
  source "tomcat-users.xml"
  owner 'tomcat_7'
  group 'tomcat_7'
  mode "0664"
  action :create
end

template "/opt/tomcat_7/conf/server.xml" do
  source "tomcat-server.xml"
  owner 'tomcat_7'
  group 'tomcat_7'
  mode "0664"
  action :create
end