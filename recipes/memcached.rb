#
# Cookbook Name:: rails_application
# Recipe:: memcached
#
# Copyright (C) 2013 Fabio Napoleoni
#

# Fetch applications bag name
bag_name = node[:rails_application][:applications_bag]
# All rails applications defined
rails_applications = data_bag_search(bag_name)

if rails_applications.any? { |app| app['memcached'] }
  include_recipe "memcached"
  service "memcached" do
    action [:enable, :start]
  end
end