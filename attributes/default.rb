#
# Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
# Cookbook Name:: rails_application
# Attributes:: default

default[:rails_application][:user] = 'rails'
default[:rails_application][:group] = 'rails'
# Rails user home directory
default[:rails_application][:home] = '/var/rails'
# This directory is used to hold all the applications
default[:rails_application][:apps_path] = default[:rails_application][:home]

# RVM installation is optional and controlled by these params
default[:rails_application][:use_rvm] = false
default[:rails_application][:rvm_install_type] = 'user'
# Stick with some known defaults for rvm parameters, you can override within the node
node.set[:rvm][:version] = '1.17.5'
# use last released MRI 1.9.3 version
node.set[:rvm][:user_default_ruby] = '1.9.3'
node.set[:rvm][:default_ruby] = '1.9.3'
node.set[:rvm][:rvmrc] = {
    :rvm_project_rvmrc => 0, # cron jobs may not work with this turned on
    :rvm_gemset_create_on_use_flag => 1,
    :rvm_trust_rvmrcs_flag => 1
}
# install options for RVM
node.set[:rvm][:user_installs] = [
  { :user => default[:rails_application][:user],
    :home => default[:rails_application][:home],
    :default_ruby => '1.9.3'
  }
]

# This is the name of the data bag used to retrieve applications
default[:rails_application][:applications_bag] = 'rails_applications'

# Nginx attributes
default[:rails_application][:nginx][:socket_path] = '/tmp'

# Newrelic attributes
default[:rails_application][:new_relic][:license_key] = false