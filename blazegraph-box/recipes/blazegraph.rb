include_recipe "blazegraph-box::tomcat"

# Make some directories for blazegraph
%w[ /data /data/blazegraph /data/blazegraph/logs ].each do |path|
  directory path do
    owner 'root'
    group 'tomcat_7'
    mode '0775'
  end
end

%w[ /opt/lake /opt/lake/etc /opt/lake/etc/blazegraph  ].each do |path|
  directory path do
    owner 'root'
    group 'tomcat_7'
    mode '0775'
  end
end

%w[ /opt/lake/webapps /opt/lake/webapps/blazegraph/ ].each do |path|
  directory path do
    owner 'root'
    group 'tomcat_7'
    mode '0775'
  end
end

remote_file "/opt/lake/webapps/blazegraph/blazegraph-2.1.2.war" do
  source "http://downloads.sourceforge.net/project/bigdata/bigdata/2.1.2/blazegraph.war?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fbigdata%2Ffiles%2Fbigdata%2F2.1.2%2F&ts=1467405619&use_mirror=heanet"
  # action :create_if_missing
  action :create
  mode "0644"
end

link "/opt/lake/webapps/blazegraph/blazegraph.war" do
  to "/opt/lake/webapps/blazegraph/blazegraph-2.1.2.war"
end

# get cookbook file for context
cookbook_file "/opt/tomcat_7/conf/Catalina/localhost/blazegraph.xml" do
  source 'blazegraph-context.xml'
  owner 'tomcat_7'
  group 'tomcat_7'
  mode '0664'
  action :create
end

# get cookbook for properties
cookbook_file node[:blazegraph][:confdir] + "/RWStore.properties" do
  source 'RWStore.properties'
  owner 'tomcat_7'
  group 'tomcat_7'
  mode '0664'
  action :create
end

# get templated logging properties
template node[:blazegraph][:confdir] + "/log4j.properties" do
  source "log4j.properties"
  owner 'tomcat_7'
  group 'tomcat_7'
  mode "0664"
  action :create
end




