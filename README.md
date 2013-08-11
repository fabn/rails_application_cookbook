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

* `node['rails_application']['user']` - User that Rails applications will run as.
* `node['rails_application']['group]` - Group for Rails applications.
* `node['rails_application']['home']` - Home directory for the created user
* `node['rails_application']['apps_path']` - Location for storing rails applications (default `node['rails_application']['home']`).
* `node['rails_application']['applications_bag']` - Databag name for applications

Other settings for rails user:

* `node[:rails_application][:ssh_keygen]` - Whether to generate a key pair for rails user (default false)
* `node[:rails_application][:ssh_keys]` - Rails user authorized ssh keys (default `[]`)
* `node[:rails_application][:shell]` - Rails user shell (default `'/bin/bash'`)
* `node[:rails_application][:enable_foreman_as_root]` - If true rails user will have sudo privileges for `foreman` command (default `true`)

Nginx related attributes

* `node['rails_application']['nginx']['socket_path']` - Path where to store unix socket when nginx is used

New Relic related attributes

* `node['rails_application']['new_relic']['license_key']` - Used with New Relic Server Monitor

### rvm.rb

This file contains attributes for configuring RVM.

* `node['rails_application']['use_rvm']` - If true rvm will be installed for the rails user (default `false`)
* `node['rails_application']['rvm_install_type']` - RVM install type (default `'user'`)

Other attributes in this file are used by [Fletcher Nichol rvm cookbook](https://github.com/fnichol/chef-rvm), see its
 README for details on them.

Recipes
=======

This cookbook provides two main recipes for installing and configuring rails applications.

* default.rb: This recipe is used to prepare the target machine to allow
 execution of rails applications. Optionally install rvm if `node[:rails_application][:use_rvm]` is true
 (false by default). RVM installation can be tuned with node attributes, see excellent
 [Fletcher Nichol rvm cookbook](https://github.com/fnichol/chef-rvm) for details.
* nginx.rb: This recipe is used to configure nginx as reverse proxy for the
 rails applications installed
* new_relic.rb: This recipe is used to install the [New Relic Server Monitor](https://newrelic.com/docs/server/) software
* mysql.rb: This recipe configures MySQL database database and users for the given applications
* memcached.rb: This recipe install and configure memcached if required be at least one application

* all.rb: This recipe include all the other recipes. Other recipe execution is controlled by data in databags, so they
 won't always be executed (e.g. if no application specifies memcached: true, memcached won't be installed).

Data Bags
=========

This cookbook reads infos about applications to create from databags. The default bag used
is rails_applications, it could be configured using bags like this one:

    {
      "id"          : "application_id",
      "app_name"    : "my_app_name",
      "server_name" : "www.example.org",
      "aliases"     : [],
      "memcached"   : true,
      "mysql": {
          "host"      : "localhost",
          "database"  : "database_name",
          "username"  : "application_username",
          "password"  : "supersecret",
          "privileges": ["select", "insert"],
          "encoding"  : "utf8",
          "collation" : "utf8_unicode_ci",
          "admin_credentials": {
            "host"     : "hostname",
            "username" : "admin_user",
            "password" : "admin_password"
          }
      }
    }

The `app_name` setting is required and is used as folder name for the application, so it should
be something that can be used for this purpose. It should be unique across all applications and
 it must not contain spaces or other non alphanumeric chars.

`server_name` and `aliases` are used in nginx configuration for the virtual host template.

The whole `mysql` block is used to configure database and user for the application.

`admin_credentials` are used to actually create the user. If not given defaults are used.

`memcached` flag tells whether the app uses memcached and if it should be installed.

Usage
=====

Include the recipe on your node or role that needs execution of rails applications

Dependencies
============

* `user`: user cookbook which works in solo mode and allows to configure user public keys
* `nginx`: opscode nginx cookbook used in `rails_application::nginx`
* `apt`: opscode apt cookbook, used in `rails_application::new_relic`
* `mysql`: opscode mysql cookbook, used in `rails_application::mysql`
* `database`: opscode database cookbook, used in `rails_application::mysql`
* `mysql_charset`: mysql charset cookbook, used in `rails_application::mysql`
* `memcached`: memcached cookbook, used in `rails_application::memcached`

License and Author
==================

- Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
