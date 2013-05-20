#
# Cookbook Name:: rails_application
# Recipe:: mysql
#
# Copyright (C) 2013 Fabio Napoleoni
#

# used for users and databases creation
include_recipe 'database::mysql'

# Fetch applications bag name
bag_name = node[:rails_application][:applications_bag]
# All rails applications defined
rails_applications = data_bag_search(bag_name)

# Return admin credentials that should be used from this databag item
def admin_credentials data_bag_item
  # mysql credentials data from databag
  credentials_from_databag = data_bag_item['mysql']['admin_credentials'] if data_bag_item['mysql']
  credentials_from_databag ||= {} # empty by default if not given through databag
  # uses symbols instead of strings for keys
  given = credentials_from_databag.inject({}) do |h, el|
    h.update(el.first.to_sym => el.last)
  end
  # use defaults where data not provided
  {
      :host => 'localhost', :username => 'root',
      :password => node['mysql']['server_root_password']
  }.merge(given)
end

# If there is an app which uses localhost (or equivalent) as database
if rails_applications.any? { |app| app['mysql'] && [node['fqdn'], 'localhost', '127.0.0.1'].include?(admin_credentials(app)[:host]) }
  # configure it through node attributes
  include_recipe 'mysql::server'
  include_recipe 'mysql_charset'
end

# create application database and users from databag items
rails_applications.each do |app|
  # if app define mysql data create database and user with privileges
  if (mysql_data = app['mysql'])
    # retrieve admin credentials from databag item
    admin_credentials = admin_credentials(app)
    # create database using admin credentials
    mysql_database mysql_data['database'] do
      connection admin_credentials
      encoding mysql_data['encoding'] || 'utf8'
      collation mysql_data['collation'] || 'utf8_general_ci'
      action :create
    end
    # grant privileges to the given user on the given database
    mysql_database_user mysql_data['username'] do
      connection admin_credentials
      password mysql_data['password']
      database_name mysql_data['database']
      # hostname vary if accessed from localhost or through hostname
      host %w(localhost 127.0.0.1).include?(mysql_data['host']) ? 'localhost' : node['fqdn']
      privileges mysql_data['privileges'] || [:all]
      action :grant
    end
  end
end
