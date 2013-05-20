#
# Cookbook Name:: rails_application
# Recipe:: data_bag
#
# Copyright (C) 2013 Fabio Napoleoni
#
# All rights reserved - Do Not Redistribute
#

# Default steps required
include_recipe 'rails_application'

# Fetch applications bag name
bag_name = node[:rails_application][:applications_bag]

# create application folders provided as data_bag items
data_bag(bag_name).each do |app|
  # fetch data from item
  app_data = data_bag_item(bag_name, app)
  # find an usable folder name
  app_name = app_data['app_name'] || app_data['id']
  # invoke definition for application
  Chef::Log.info "Invoking rails_application definition for application #{app_name}"
  rails_application app_name do
    application_config app_data
  end
end
