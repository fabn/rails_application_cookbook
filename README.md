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

Nginx related attributes

* `node['rails_application']['nginx']['socket_path']` - Path where to store unix socket when nginx is used

New Relic related attributes

* `node['rails_application']['new_relic']['license_key']` - Used with New Relic Server Monitor

Recipes
=======

This cookbook provides two main recipes for installing Nginx.

* default.rb: This recipe is used to prepare the target machine to allow
 execution of rails applications
* nginx.rb: This recipe is used to configure nginx as reverse proxy for the
 rails applications installed
* new_relic.rb: This recipe is used to install the [New Relic Server Monitor](https://newrelic.com/docs/server/) software

Data Bags
=========

This cookbook reads infos about applications to create from databags. The default bag used
is rails_applications, it could be configured using bags like this one:

    {
      "id"          : "application_id",
      "app_name"    : "my_app_name",
      "server_name" : "www.example.org",
      "aliases"     : []
    }

The `app_name` setting is required and is used as folder name for the application, so it should
be something that can be used for this purpose. It should be unique across all applications and
 it must not contain spaces or other non alphanumeric chars.

`server_name` and `aliases` are used in nginx configuration for the virtual host template.

Usage
=====

Include the recipe on your node or role that needs execution of rails applications

Dependencies
============

* `nginx`: opscode nginx cookbook used in `rails_application::nginx`

License and Author
==================

- Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
