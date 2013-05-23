#
# Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
# Cookbook Name:: rails_application
# Attributes:: rvm

# RVM installation is optional and controlled by these params
default[:rails_application][:use_rvm] = false
default[:rails_application][:rvm_install_type] = 'user'
# use last released MRI 1.9.3 version
#default[:rvm][:user_default_ruby] = '1.9.3'
#default[:rvm][:default_ruby] = '1.9.3'
#default[:rvm][:rvmrc] = {
#    :rvm_project_rvmrc => 0, # cron jobs may not work with this turned on
#    :rvm_gemset_create_on_use_flag => 1,
#    :rvm_trust_rvmrcs_flag => 1
#}
## install options for RVM
#default[:rvm][:user_installs] = [
#    {:user => default[:rails_application][:user],
#     :home => default[:rails_application][:home],
#     :default_ruby => '1.9.3'
#    }
#]
## global gems for system wide installation
#default[:rvm][:global_gems] = [
#    {:name => 'bundler'},
#    {:name => 'rake'},
#    {:name => 'rubygems-bundler', :action => 'remove'}
#]
## global gems for user installation
#default['rvm']['user_global_gems'] = [
#    {:name => 'bundler'},
#    {:name => 'rake'},
#    {:name => 'rubygems-bundler', :action => 'remove'}
#]
