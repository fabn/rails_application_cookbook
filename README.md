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

Recipes
=======

This cookbook provides two main recipes for installing Nginx.

* default.rb: This recipe is used to prepare the target machine to allow
 execution of rails applications

Data Bags
=========

Usage
=====

Include the recipe on your node or role that needs execution of rails applications

License and Author
==================

- Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
