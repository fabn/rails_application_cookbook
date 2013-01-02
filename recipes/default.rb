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
