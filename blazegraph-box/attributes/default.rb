# use the latest JDK
default[:java][:jdk_version] = '8'
default['java']['install_flavor'] = 'oracle'
default['java']['set_etc_environment'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true

# defaults for blazegraph;
default[:blazegraph] = {
    :confdir => '/opt/lake/etc/blazegraph',
    :logdir => '/data/blazegraph/logs'
}