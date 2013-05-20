#
# Cookbook Name:: rails_application
# Recipe:: new_relic
#
# Copyright (C) 2013 Fabio Napoleoni
#

include_recipe 'apt'

unless node[:rails_application][:new_relic][:license_key]
  Chef::Log.fatal('License key is missing, please provide a valid value for node[:rails_application][:new_relic][:license_key]')
  raise ArgumentError, 'License key is missing, please provide a valid value for node[:rails_application][:new_relic][:license_key]'
end

# Add new relic repository
apt_repository 'new_relic' do
  uri 'http://apt.newrelic.com/debian/'
  components ['newrelic', 'non-free']
  key 'http://download.newrelic.com/548C16BF.gpg'
  notifies :run, resources(:execute => 'apt-get update'), :immediately
end

# Install new relic monitor daemon
apt_package 'newrelic-sysmond' do
  action :upgrade
end

# Install the license key
execute 'nrsysmond-config' do
  command "nrsysmond-config --set license_key=#{node[:rails_application][:new_relic][:license_key]}"
  action :run
  not_if "grep '#{node[:rails_application][:new_relic][:license_key]}' /etc/newrelic/nrsysmond.cfg "
end

service 'newrelic-sysmond' do
  supports :status => true, :restart => true, :reload => false
  action [ :enable, :start ]
end