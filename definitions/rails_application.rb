# This is a definition used to generate a rails application structure
# according to the given parameters

define :rails_application, :enable => true do

  application_name = params[:name]

  # Define needs for this rails application
  options = {
      'rvm' => 'user',
      'redis' => false,
      'memcached' => false,
      'capistrano' => true,
      'frontend' => 'nginx',
      'mysql' => false
  }.merge(params[:application_config])

  # Create application folder
  directory "#{node[:rails_application][:apps_path]}/#{application_name}" do
    owner node[:rails_application][:user]
    group node[:rails_application][:group]
    mode '0755'
  end

  # Install needed stuff for this rails application

  # Memcached
  include_recipe 'memcached' if options['memcached']

  # Redis
  # include_recipe 'redis' if options[:redis]

  # RVM
  # Install rvm if requested
  if options['rvm']
    # install type from application configuration
    Chef::Log.info "Installing rvm with \"rvm::#{options['rvm']}\" recipe as requested"
    # install using rvm cookbook
    include_recipe "rvm::#{options['rvm']}"
  end

  # Create mysql user for application if required
  # if app define mysql data create database and user with privileges
  if (mysql_data = options['mysql'])
    # create database using admin credentials
    mysql_database mysql_data['database'] do
      connection node[:rails_application][:mysql_admin_credentials]
      encoding mysql_data['encoding'] || 'utf8'
      collation mysql_data['collation'] || 'utf8_general_ci'
      action :create
    end
    # grant privileges to the given user on the given database
    mysql_database_user mysql_data['username'] do
      connection node[:rails_application][:mysql_admin_credentials]
      password mysql_data['password']
      database_name mysql_data['database']
      # hostname vary if accessed from localhost or through hostname
      host %w(localhost 127.0.0.1).include?(mysql_data['host']) ? 'localhost' : node['fqdn']
      privileges mysql_data['privileges'] || [:all]
      action :create
    end
  end

  # Application variables
  application_path = File.join(node[:rails_application][:apps_path], application_name)
  # Webserver document root, with rails should be pointed to public, optionally using capistrano layout
  document_root = File.join(options[:capistrano] ? File.join(application_path, 'current') : application_path, 'public')

  # Configure frontend for the application
  case options[:frontend]
    when 'nginx'
      # install and enable nginx server from packages
      include_recipe 'nginx'
      # create nginx configuration for selected application
      template "#{node['nginx']['dir']}/sites-available/#{application_name}" do
        # configure the template file
        source 'nginx_vhost.conf.erb'
        owner 'root'
        group 'root'
        mode 0644
        # build server name from data bag configuration items
        server_names = [options['server_name']]
        # append other alias
        server_names += options['aliases'] if options['aliases'] && options['aliases'].any?
        # pass variables from data bag and node settings
        variables({:app_path => document_root, :app_name => application_name, :server_names => server_names,
                   :app_socket => "#{node[:rails_application][:nginx][:socket_path]}/#{application_name}.sock"})
      end
      # enable vhost in nginx
      nginx_site application_name
    when 'apache'
      # Apache definition
      web_app application_name do
        template 'apache_vhost.conf.erb'
        # any param given here is forwarded to the template under params hash
        server_name application_name
        server_aliases options['aliases'] if options['aliases'] && options['aliases'].any?
        document_root document_root
        # Apache virtual host based on port if given (default 80)
        port options['apache']['port'] if options['apache']['port']
        # When apache is used with mod_proxy the proxy port should be set in
        # unicorn config and apache vhost config
        proxy_port options['apache']['proxy_port']
      end

    else
      Chef::Log.warn("No frontend defined for application #{application_name}, it will be accessible depending on rails configuration")
  end

end
