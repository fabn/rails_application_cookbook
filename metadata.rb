name             "rails_application"
maintainer       "Fabio Napoleoni"
maintainer_email "f.napoleoni@gmail.com"
license          "All rights reserved"
description      "Installs/Configures one or more rails application using a standard structure"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.1"

recipe "rails_application", "This cookbook prepares a target machine to host any number of rails applications"

depends 'user', '~> 0.3.0'
depends 'nginx', '~> 1.1.2'
depends 'apt', '~> 1.7.0'
depends 'mysql', '~> 3.0.0'
depends 'database', '~> 1.3.12'
depends 'memcached', '~> 1.1.2'
depends 'rvm', '~> 0.9.0'
depends 'apache2', '~> 1.6.0'
depends 'logrotate'
depends 'sudo', '~> 2.1.4'
depends 'redis', '~> 2.1.1'