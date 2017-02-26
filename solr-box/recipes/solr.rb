
# This is currently happening in the mongo recipe, which runs earlier than this
%w[ /data /data/solr ].each do |path|
  directory path do
    owner 'root'
    group 'root'
    mode '0775'
  end
end

# install solr
include_recipe 'solr_6::install'

%w[ /data /data/solr ].each do |path|
  directory path do
    owner 'root'
    group 'solr'
    mode '0775'
  end
end

%w[ /data/solr/data/prodidx /data/solr/data/prodidx/conf /data/solr/data/demoidx /data/solr/data/demoidx/conf ].each do |path|
  directory path do
    owner 'solr'
    group 'solr'
    mode '0775'
  end
end

# Files to instantiate a core
cookbook_file "/data/solr/data/prodidx/conf/solrconfig.xml" do
  source 'prodidx-solrconfig.xml'
  owner 'solr'
  group 'solr'
  mode '0644'
  action :create
end

cookbook_file "/data/solr/data/prodidx/conf/schema.xml" do
  source 'prodidx-schema.xml'
  owner 'solr'
  group 'solr'
  mode '0644'
  action :create
end

# Files to instantiate a core
cookbook_file "/data/solr/data/demoidx/conf/solrconfig.xml" do
  source 'demoidx-solrconfig.xml'
  owner 'solr'
  group 'solr'
  mode '0644'
  action :create
end

cookbook_file "/data/solr/data/demoidx/conf/schema.xml" do
  source 'demoidx-schema.xml'
  owner 'solr'
  group 'solr'
  mode '0644'
  action :create
end

template "/opt/solr/server/etc/jetty-http.xml" do
  source "jetty-http.xml"
  mode "0664"
  action :create
end