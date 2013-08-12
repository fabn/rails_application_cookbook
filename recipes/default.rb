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

# add users to the group if given
group node[:rails_application][:group] do
  members node[:rails_application][:group_users]
  append true
  only_if { node[:rails_application][:group_users].any? }
end

# Enable application user to execute foreman commands as root
if node[:rails_application][:enable_foreman_upstart_support]
  directory '/etc/init/sites' do
    owner 'root'
    group node[:rails_application][:group]
    mode '2775'
  end
  # Management tools
  management_commands = %w(start stop restart status reload).map do |cmd|
    # allowed only with a `sites/\w+` argument
    "/sbin/#{cmd} sites/*"
  end
  # Enable user to restart services in sites folder
  sudo "#{node[:rails_application][:user]}_services" do
    user node[:rails_application][:user]
    runas 'root'
    commands management_commands
    nopasswd true
  end
end
