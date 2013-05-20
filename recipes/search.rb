#
# Cookbook Name:: rails_application
# Recipe:: search
#
# Copyright (C) 2013 Fabio Napoleoni
#
# All rights reserved - Do Not Redistribute
#

# Default steps required
include_recipe 'rails_application'

if Chef::Config[:solo]
  Chef::Log.info 'This recipe uses databag search it will fail unless you have the chef-solo-search' +
                     'cookbook included for the node (see https://github.com/edelight/chef-solo-search)'
end

# Fetch applications bag name
bag_name = node[:rails_application][:applications_bag]

# search applications assigned to this node
search(bag_name, "fqdn:#{node[:fqdn]}").each do |app_data|
  # find an usable folder name
  app_name = app_data['app_name'] || app_data['id']
  # invoke definition for application
  Chef::Log.info "Invoking rails_application definition for application #{app_name}"
  rails_application app_name do
    application_config app_data
  end
end
