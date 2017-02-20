# use the latest JDK
default[:java][:jdk_version] = '8'
default['java']['install_flavor'] = 'oracle'
default['java']['set_etc_environment'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true

# sane defaults for PostgreSQL
default[:postgresql][:password][:postgres] = 'rootpass'
default[:postgresql][:config][:listen_addresses] = 'localhost'
default[:postgresql][:config][:port] = '5432'

# sane defaults for Fedora;
default[:fedora] = {
  :installpaths => {
    :fedora => '/usr/share/fedora',
    :tomcat => '/usr/share/fedora/tomcat'
  },
  :database => {
    :host => 'localhost',
    :name => 'ispn',
    :username => 'fedoraAdmin',
    :password => 'fedoraAdmin'
  },
  :hostname => 'localhost',
  :context => 'fcrepo',
  :port => '8080',
  :adminpassword => 'fedoraAdmin',
  :fedorahome => '/data/fcrepo',
  :logdir => '/data/fcrepo/logs'
}