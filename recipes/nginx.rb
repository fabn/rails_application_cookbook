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
