
## Below added to get around an issue with the recipe.  Fine for production?
node.force_override['postgresql']['dir'] = '/var/lib/pgsql/data'
node.force_override['postgresql']['config']['data_directory'] = '/var/lib/pgsql/data'

# node.override['postgresql']['pg_hba'] = [{:type => 'host', :db => 'all', :user => 'all', :addr => '192.168.99.0/24', :method => 'md5'}]
case node['virtualization']['system']
    when "docker"
        node.override['postgresql']['pg_hba'] = [
            { :type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident' },
            { :type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident' },
            { :type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5' },
            { :type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5' },
            { :type => 'host', :db => 'all', :user => 'all', :addr => '192.168.99.0/24', :method => 'md5'}
        ]
        node.force_override['postgresql']['config']['listen_addresses'] = '*'
end

# install postgresql
include_recipe 'postgresql'
include_recipe 'postgresql::server'
include_recipe 'postgresql::config_pgtune'
include_recipe 'database::postgresql'

# set database type to postgresql
node.default[:fedora][:database][:type] = 'postgresql'

# define the database connection
postgres_connection = ({
  :host => node[:combine][:postgres][:host],
  :username => 'postgres',
  :password => node[:postgresql][:password][:postgres]}
)

# create the combine postgresql database
postgresql_database node[:combine][:postgres][:name] do
  connection postgres_connection
  action :create
end

# create the combine postgresql user
postgresql_database_user node[:combine][:postgres][:username] do
  connection postgres_connection
  password node[:combine][:postgres][:password]
  database_name node[:combine][:postgres][:name]
  action :create
end

# grant permissions to localhost
postgresql_database_user node[:combine][:postgres][:username] do
  connection postgres_connection
  password node[:combine][:postgres][:password]
  database_name node[:combine][:postgres][:name]
  host node[:combine][:postgres][:host]
  action :grant
end


