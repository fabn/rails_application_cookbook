#
# Cookbook Name:: rails_application
# Recipe:: mysql
#
# Copyright (C) 2013 Fabio Napoleoni
#

# used for users and databases creation
include_recipe "database::mysql"

# Fetch applications bag name
bag_name = node[:rails_application][:applications_bag]

# Return admin credentials that should be used from this databag item
def admin_credentials data_bag_item
  data_bag_item['admin_credentials'] ?
      # uses symbols instead of strings as keys in the returned version from databag
      mysql_data['admin_credentials'].inject({}) { |h, el| h.update(el.first.to_sym => el.last) } :
      {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
end

# Don't install unless at least an app connect to localhost
install_mysql_server = false
# see if mysql should be installed on localhost
data_bag(bag_name).each do |app|
  # fetch data from item
  app_data = data_bag_item(bag_name, app)
  # if app define mysql check if server installation is required
  if app_data['mysql']
    # install mysql server only if at least an item uses localhost (or its variants)
    install_mysql_server ||= [node['fqdn'], 'localhost', '127.0.0.1'].include?(admin_credentials(app_data)[:host])
  end
end
# install the database server if required
if install_mysql_server
  # configure it through node attributes
  include_recipe "mysql::server"
  include_recipe "mysql_charset"
end

# create application database and users from databag items
data_bag(bag_name).each do |app|
  # fetch data from item
  app_data = data_bag_item(bag_name, app)
  # mysql data
  mysql_data = app_data['mysql']
  # if app define mysql data create database and user with privileges
  if mysql_data
    # retrieve admin credentials from databag item
    admin_credentials = admin_credentials(app_data)
    # create database using admin credentials
    mysql_database mysql_data['database'] do
      connection admin_credentials
      encoding mysql_data['encoding']
      collation mysql_data['collation']
      action :create
    end
    # grant privileges to the given user on the given database
    mysql_database_user mysql_data['username'] do
      connection admin_credentials
      password mysql_data['password']
      database_name mysql_data['database']
      # hostname vary if accessed from localhost or through hostname
      host %w(localhost 127.0.0.1).include?(mysql_data['host']) ? 'localhost' : node['fqdn']
      privileges mysql_data['privileges']
      action :grant
    end
  end
end
