#
# Cookbook Name:: rails_application
# Recipe:: default
#
# Copyright (C) 2013 Fabio Napoleoni
# 
# All rights reserved - Do Not Redistribute
#

# use fnichols resource which allows ssh keys management
# even in chef solo mode. No need for search.
user_account node[:rails_application][:user] do
  create_group node[:rails_application][:group]
  comment 'User for running rails applications'
  home node[:rails_application][:home]
  ssh_keygen node[:rails_application][:ssh_keygen]
  ssh_keys node[:rails_application][:ssh_keys]
  shell node[:rails_application][:shell]
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

# Install rvm if requested
if node[:rails_application][:use_rvm]
  # install type from configuration
  type = %w(user system).include?(node[:rails_application][:rvm_install_type]) ?
      node[:rails_application][:rvm_install_type] : 'user'
  Chef::Log.info "Installing rvm with \"rvm::#{type}\" recipe as requested"
  # install using rvm cookbook
  include_recipe "rvm::#{type}"
end