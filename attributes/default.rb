#
# Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
# Cookbook Name:: rails_application
# Attributes:: default

default[:rails_application][:user] = 'rails'
default[:rails_application][:group] = 'rails'
default[:rails_application][:group_users] = []
# Rails user home directory
default[:rails_application][:home] = '/var/rails'
# Other settings for rails user
default[:rails_application][:ssh_keygen] = false
default[:rails_application][:ssh_keys] = []
default[:rails_application][:shell] = '/bin/bash'

# This directory is used to hold all the applications
default[:rails_application][:apps_path] = default[:rails_application][:home]

# This is the name of the data bag used to retrieve applications
default[:rails_application][:applications_bag] = 'rails_applications'

# Nginx attributes
default[:rails_application][:nginx][:socket_path] = '/tmp'

# Newrelic attributes
default[:rails_application][:new_relic][:license_key] = false

# Default attributes for dependent components
default[:rails_application][:mysql_admin_credentials] = {
    host: 'localhost',
    username: 'root',
    password: node[:mysql][:server_root_password]
}

default[:memcached][:listen] = '127.0.0.1'

# Foreman support for rails applications
default[:rails_application][:enable_foreman_as_root] = true
