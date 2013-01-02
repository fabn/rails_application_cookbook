#
# Cookbook Name:: rails_application
# Recipe:: default
#
# Copyright (C) 2013 Fabio Napoleoni
# 
# All rights reserved - Do Not Redistribute
#
group node[:rails_application][:group]

# create the user for running applications
user node[:rails_application][:user] do
  comment "User for running rails applications"
  group node[:rails_application][:group]
  shell "/bin/bash"
  home node[:rails_application][:home]
end

# create the directory used as base path for different applications
directory node[:rails_application][:apps_path] do
  owner node[:rails_application][:user]
  group node[:rails_application][:group]
  mode '0755'
end

# Fetch applications bag name
bag_name = node[:rails_application][:applications_bag]

# create application folders provided as data_bag items
data_bag(bag_name).each do |app|
  # fetch data from item
  app_data = data_bag_item(bag_name, app)
  # find an usable folder name
  app_name = app_data['app_name'] || app_data['id']
  # create folder for application
  directory "#{node[:rails_application][:apps_path]}/#{app_name}" do
    owner node[:rails_application][:user]
    group node[:rails_application][:group]
    mode '0755'
  end
end
