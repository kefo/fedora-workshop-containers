include_recipe 'java'

#
# Creating `group`
group 'tomcat' do
  action :create # This is a default behaviour
end

# Creating user `tomcat`
user 'tomcat' do
  group 'tomcat'
  home '/opt/tomcat'
  shell '/bin/nologin'
  uid '1234'
  action :create
end

# Create directory

directory ('/opt/tomcat') do
  owner 'tomcat'
  group 'tomcat'
end

karaf 'install karaf' do
    install_path  '/opt/lake/'
    install_java  false
    version       '4.0.5'
    action        :install
end

execute 'delay' do
  command 'sleep 60'
end

bash 'fix_java_home' do
    code <<-EOH
        cp /opt/lake/karaf/bin/karaf-service /opt/lake/karaf/bin/karaf-service.original
        sed 's/JAVA_HOME="null"/JAVA_HOME=\\/usr\\/lib\\/jvm\\/java/' /opt/lake/karaf/bin/karaf-service.original > /opt/lake/karaf/bin/karaf-service
        
        cp /opt/lake/karaf/etc/karaf-wrapper.conf /opt/lake/karaf/etc/karaf-wrapper.conf.original
        sed 's/set.default.JAVA_HOME=null/set.default.JAVA_HOME=\\/usr\\/lib\\/jvm\\/java/' /opt/lake/karaf/etc/karaf-wrapper.conf.original > /opt/lake/karaf/etc/karaf-wrapper.conf
        EOH
end

=begin
karaf_feature_repository 'hawtio' do
    install_path  '/opt/lake/'
    
    # See https://github.com/JCapriotti/apache-karaf-cookbook/blob/master/CHANGELOG.md#300---11292016
    #client_user   'karaf'
    
    :install
end

karaf_feature 'hawtio' do
    install_path  '/opt/lake/'
    :install
end

#karaf_feature_repository 'mvn:org.fcrepo.camel/toolbox-features/LATEST/xml/features' do
karaf_feature_repository 'mvn:org.fcrepo.camel/toolbox-features/4.6.2/xml/features' do
    install_path  '/opt/lake/'
    
    # See https://github.com/JCapriotti/apache-karaf-cookbook/blob/master/CHANGELOG.md#300---11292016
    #client_user   'karaf'
    
    :install
end 

karaf_feature 'fcrepo-service-activemq' do
    install_path  '/opt/lake/'
    :install
end

karaf_feature 'activemq-broker' do
    install_path  '/opt/lake/'
    :install
end  

karaf_feature 'activemq-broker-noweb' do
    install_path  '/opt/lake/'
    :install
end  

karaf_feature 'fcrepo-reindexing' do
    install_path  '/opt/lake/'
    :install
end  

karaf_feature 'camel-saxon' do
    install_path  '/opt/lake/'
    :install
end 

karaf_feature 'camel-http4' do
    install_path  '/opt/lake/'
    :install
end 

karaf_feature 'camel-http' do
    install_path  '/opt/lake/'
    :install
end 

karaf_feature 'camel-mustache' do
    install_path  '/opt/lake/'
    :install
end 

karaf_feature 'camel-jackson' do
    install_path  '/opt/lake/'
    :install
end 


# Deploy a org.fcrepo.camel.service.activemq.cfg that references the vm:// protocol.
cookbook_file "/opt/lake/karaf/etc/org.fcrepo.camel.service.activemq.cfg" do
  source 'org.fcrepo.camel.service.activemq.cfg'
  mode '0664'
  action :create
end

# Deploy a org.fcrepo.camel.service.activemq.cfg that references the vm:// protocol.
cookbook_file "/opt/lake/karaf/etc/activemq.xml" do
  source 'activemq.xml'
  mode '0664'
  action :create
end


#######
# Docker configs
#######

# triplestore cfg
template "/opt/lake/karaf/etc/edu.artic.geneva.triplestore.prod.cfg" do
    source "edu.artic.geneva.triplestore.cfg"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:triplestore_indexing][:docker]
    )
    action :create
end

# triplestore deploy
template "/opt/lake/karaf/deploy/triplestore-indexing-docker.xml" do
    source "triplestore-indexing.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:triplestore_indexing][:docker]
    )
    action :create
end

#solrize cfg
template "/opt/lake/karaf/etc/edu.artic.geneva.solrize.prod.cfg" do
    source "edu.artic.geneva.solrize.cfg"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:solrize][:docker]
    )
    action :create
end

#solrize deploy
template "/opt/lake/karaf/deploy/solrize-docker.xml" do
    source "solrize.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:solrize][:docker]
    )
    action :create
end

# reindex-by-type deploy
template "/opt/lake/karaf/deploy/reindex-type-docker.xml" do
    source "reindex-type.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:reindexing_type][:docker]
    )
    action :create
end

# reindexing cfg
template "/opt/lake/karaf/etc/org.fcrepo.camel.reindexing.cfg" do
  source "org.fcrepo.camel.reindexing.cfg"
  mode "0664"
  variables(
        :routevars => node[:karaf_fcrepo_features][:reindexing][:docker]
    )
  action :create
end

# reindexing/camelservice cfg
template "/opt/lake/karaf/etc/org.fcrepo.camel.service.cfg" do
  source "org.fcrepo.camel.service.cfg"
  mode "0664"
  variables(
        :routevars => node[:karaf_fcrepo_features][:reindexing][:docker]
    )
  action :create
end



# Set up directories
%w[ /opt/lake/karaf/deploy-envs /opt/lake/karaf/deploy-envs/prod /opt/lake/karaf/deploy-envs/test /opt/lake/karaf/deploy-envs/dev /opt/lake/karaf/etc-envs /opt/lake/karaf/etc-envs/prod /opt/lake/karaf/etc-envs/test /opt/lake/karaf/etc-envs/dev ].each do |path|
  directory path do
    owner 'root'
    group 'tomcat'
    mode '0775'
  end
end

######
# AIC deployed config files.
######

# TRIPLESTORE INDEXING
template "/opt/lake/karaf/deploy-envs/dev/triplestore-indexing-dev.xml" do
    source "triplestore-indexing.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:triplestore_indexing][:dev]
    )
    action :create
end

template "/opt/lake/karaf/etc-envs/dev/edu.artic.geneva.triplestore.dev.cfg" do
    source "edu.artic.geneva.triplestore.cfg"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:triplestore_indexing][:dev]
    )
    action :create
end

template "/opt/lake/karaf/deploy-envs/test/triplestore-indexing-test.xml" do
    source "triplestore-indexing.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:triplestore_indexing][:test]
    )
    action :create
end

template "/opt/lake/karaf/etc-envs/test/edu.artic.geneva.triplestore.test.cfg" do
    source "edu.artic.geneva.triplestore.cfg"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:triplestore_indexing][:test]
    )
    action :create
end

template "/opt/lake/karaf/deploy-envs/prod/triplestore-indexing-prod.xml" do
    source "triplestore-indexing.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:triplestore_indexing][:prod]
    )
    action :create
end

template "/opt/lake/karaf/etc-envs/prod/edu.artic.geneva.triplestore.prod.cfg" do
    source "edu.artic.geneva.triplestore.cfg"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:triplestore_indexing][:prod]
    )
    action :create
end


## SOLRIZE
template "/opt/lake/karaf/deploy-envs/dev/solrize-dev.xml" do
    source "solrize.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:solrize][:dev]
    )
    action :create
end

template "/opt/lake/karaf/etc-envs/dev/edu.artic.geneva.solrize.dev.cfg" do
    source "edu.artic.geneva.solrize.cfg"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:solrize][:dev]
    )
    action :create
end

template "/opt/lake/karaf/deploy-envs/test/solrize-test.xml" do
    source "solrize.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:solrize][:test]
    )
    action :create
end

template "/opt/lake/karaf/etc-envs/test/edu.artic.geneva.solrize.test.cfg" do
    source "edu.artic.geneva.solrize.cfg"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:solrize][:test]
    )
    action :create
end

template "/opt/lake/karaf/deploy-envs/prod/solrize-prod.xml" do
    source "solrize.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:solrize][:prod]
    )
    action :create
end

template "/opt/lake/karaf/etc-envs/prod/edu.artic.geneva.solrize.prod.cfg" do
    source "edu.artic.geneva.solrize.cfg"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:solrize][:prod]
    )
    action :create
end


# REINDEX BY TYPE
template "/opt/lake/karaf/deploy-envs/dev/reindex-type-dev.xml" do
    source "reindex-type.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:reindexing_type][:dev]
    )
    action :create
end

template "/opt/lake/karaf/deploy-envs/test/reindex-type-test.xml" do
    source "reindex-type.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:reindexing_type][:test]
    )
    action :create
end

template "/opt/lake/karaf/deploy-envs/prod/reindex-type-prod.xml" do
    source "reindex-type.xml"
    mode "0664"
    variables(
        :routevars => node[:karaf_fcrepo_features][:reindexing_type][:prod]
    )
    action :create
end

=end


