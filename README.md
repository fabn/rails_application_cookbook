Rails Application Cookbook
==========================

This cookbook provides recipes used to configure a rails application
using various configurations

Requirements
============

Chef version 0.10.10+.

Cookbooks
---------

Platform
--------

The following platforms are supported and tested under test kitchen:

* Debian

May work with other distros (especially Ubuntu)

Attributes
==========

Here are the configuration attributes used in this cookbooks

### default.rb

* `node['rails_application']['apps_path']` - Location for storing rails applications.
* `node['rails_application']['user']` - User that Rails applications will run as.
* `node['rails_application']['group]` - Group for Rails applications.
* `node['rails_application']['home']` - Home directory for the created user
* `node['rails_application']['applications_bag']` - Databag name for applications

Recipes
=======

This cookbook provides two main recipes for installing Nginx.

* default.rb: This recipe is used to prepare the target machine to allow
 execution of rails applications
* nginx.rb: This recipe is used to configure nginx as reverse proxy for the
 rails applications installed

Data Bags
=========

This cookbook read infos about applications to create from databags. The default bag used
is rails_applications, it could be configured using bags like this one:

    {
      "id"         : "application_id",
      "app_name"   : "my_app_name",
      "app_folder" : "my_app_folder"
    }

Usage
=====

Include the recipe on your node or role that needs execution of rails applications

Dependencies
============

* `nginx`: opscode nginx cookbook used in `rails_application::nginx`

License and Author
==================

- Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
