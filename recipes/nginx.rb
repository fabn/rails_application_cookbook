#
# Cookbook Name:: rails_application
# Recipe:: nginx
#
# Copyright (C) 2013 Fabio Napoleoni
#
# All rights reserved - Do Not Redistribute
#

# include default recipe from cookbook
include_recipe "rails_application::default"
# install and enable nginx server from packages
include_recipe "nginx"

# Fetch applications bag name
bag_name = node[:rails_application][:applications_bag]

# create application folders provided as data_bag items
data_bag(bag_name).each do |app|
  # fetch data from item
  app_data = data_bag_item(bag_name, app)
  # find an usable virtual host name
  app_name = app_data['app_name'] || app_data['id']
  # actual app path
  app_path = "#{node[:rails_application][:apps_path]}/#{app_name}"
  # create nginx configuration for selected application
  template "#{node['nginx']['dir']}/sites-available/#{app_name}" do
    # configure the template file
    source 'nginx_vhost.erb'
    owner "root"
    group "root"
    mode 0644
    # build server name from data bag configuration items
    server_names = [app_data['server_name']]
    # append other alias
    server_names += app_data['aliases'] if app_data['aliases'] && app_data['aliases'].any?
    # pass variables from data bag and node settings
    variables({:app_path => app_path, :app_name => app_name, :server_names => server_names,
               :app_socket => "#{node[:rails_application][:nginx][:socket_path]}/#{app_name}.sock"})
  end
  # enable vhost in nginx
  nginx_site app_name
end

