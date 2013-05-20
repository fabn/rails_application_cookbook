#
# Cookbook Name:: rails_application
# Recipe:: all
#
# Copyright (C) 2013 Fabio Napoleoni
#

include_recipe 'rails_application::default'
include_recipe 'rails_application::nginx'
include_recipe 'rails_application::mysql'
include_recipe 'rails_application::memcached'

# include only if key is specified, to avoid errors
if node[:rails_application][:new_relic][:license_key]
  include_recipe 'rails_application::new_relic'
end
