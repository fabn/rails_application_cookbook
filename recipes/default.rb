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
