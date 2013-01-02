name             "rails_application"
maintainer       "Fabio Napoleoni"
maintainer_email "f.napoleoni@gmail.com"
license          "All rights reserved"
description      "Installs/Configures one or more rails application using a standard structure"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe "rails_application", "This recipe prepare the target machine to host any number of rails applications"

depends 'nginx', '~> 1.1.2'

