
node.force_override['postgresql']['dir'] = '/var/lib/pgsql/data'
node.force_override['postgresql']['config']['data_directory'] = '/var/lib/pgsql/data'

include_recipe 'database::postgresql'

service "postgresql-9.4" do 
  action :start
end

# define the database connection
postgres_connection = ({
  :host => node[:fedora][:database][:host],
  :username => 'postgres',
  :password => node[:postgresql][:password][:postgres]}
)

# create the fedora postgresql database
postgresql_database node[:fedora][:database][:name] do
  connection postgres_connection
  action :create
end

# create the fedora postgresql user
postgresql_database_user node[:fedora][:database][:username] do
  connection postgres_connection
  password node[:fedora][:database][:password]
  database_name node[:fedora][:database][:name]
  action :create
end

# grant permissions to localhost
postgresql_database_user node[:fedora][:database][:username] do
  connection postgres_connection
  password node[:fedora][:database][:password]
  database_name node[:fedora][:database][:name]
  host node[:fedora][:database][:host]
  action :grant
end
