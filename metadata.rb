name             "rails_application"
maintainer       "Fabio Napoleoni"
maintainer_email "f.napoleoni@gmail.com"
license          "All rights reserved"
description      "Installs/Configures one or more rails application using a standard structure"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe "rails_application", "This recipe prepare the target machine to host any number of rails applications"

depends 'user', '~> 0.3.0'
depends 'nginx', '~> 1.1.2'
depends 'apt', '~> 1.7.0'
depends 'mysql', '~> 2.1.0'
depends 'database', '1.3.6'
depends 'mysql_charset', '~> 0.0.1'
depends 'memcached', '~> 1.1.2'
depends 'rvm', '~> 0.9.0'