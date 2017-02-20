
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

%w[ /data/solr/data/prodidx /data/solr/data/prodidx/conf  ].each do |path|
  directory path do
    owner 'solr'
    group 'solr'
    mode '0775'
  end
end

# Files to instantiate a core
cookbook_file "/data/solr/data/prodidx/conf/solrconfig.xml" do
  source 'solrconfig.xml'
  owner 'solr'
  group 'solr'
  mode '0644'
  action :create
end

cookbook_file "/data/solr/data/prodidx/conf/schema.xml" do
  source 'schema.xml'
  owner 'solr'
  group 'solr'
  mode '0644'
  action :create
end
