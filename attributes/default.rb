#
# Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
# Cookbook Name:: rails_application
# Attributes:: default

default[:rails_application][:user] = 'rails'
default[:rails_application][:group] = 'rails'
# Rails user home directory
default[:rails_application][:home] = '/var/rails'
# This directory is both the user
default[:rails_application][:apps_path] = default[:rails_application][:home]
