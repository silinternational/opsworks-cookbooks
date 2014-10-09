# Recipe installs and configures dependencies for Mail Admin

# Required packages
packages = ["git", "httpd", "php", "php-mcrypt", 
			"php-mysql", "php-pdo", "php-xml", 
			"php-mbstring", "php-ldap"]

packages.each do |name|
	package name do
		action :install
	end
end

# Create vhost for mail-admin.local
web_app "mailadmin" do
	server_name node['vhost']['server_name']
	server_aliases node['vhost']['server_aliases']
	docroot node['vhost']['docroot']
	allow_override node['vhost']['allow_override']
	server_port node['vhost']['port']
	cookbook "apache2"
end

include_recipe "database::mysql"

# Create mailadmin database
mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}
mysql_database 'mailadmin' do
  connection mysql_connection_info
  action :create
end
mysql_database 'mailadmin_test' do
  connection mysql_connection_info
  action :create
end

# Create maildmin database users
mysql_database_user 'mailadmin' do
	username 'mailadmin'
	password 'mailadmin'
	database_name 'mailadmin'
	privileges [:all]
	connection mysql_connection_info
	action [:create,:grant]
end
mysql_database_user 'mailadmin_test' do
	username 'mailadmin_test'
	password 'mailadmin_test'
	database_name 'mailadmin_test'
	privileges [:all]
	connection mysql_connection_info
	action [:create,:grant]
end

# Disable EnableSendFile in apache, needed when using vagrant on windows
file "/etc/httpd/conf.d/sendfile.conf" do
	owner "root"
	group "root"
	mode "0644"
	content "EnableSendfile off"
	action :create
	notifies :restart, "service[apache2]", :immediately
end

# Deploy mailadmin from git
node['deploy'].each do |appname, deploy|
	application appname do
		path  deploy['deploy_to']
		owner deploy['owner']
		group deploy['group']

		repository deploy['scm']['repository']
		revision   deploy['scm']['revision']
		deploy_key deploy['scm']['ssh_key']
	end

	# Update folder permissions
	directory "#{deploy['deploy_to']}/current/web-files/protected/runtime" do
		owner "apache"
		group "apache"
		mode "0775"
	end
	directory "#{deploy['deploy_to']}/current/web-files/application/assets" do
		owner "apache"
		group "apache"
		mode "0775"
	end

	# Create simplesaml symlink if needed
	link "#{deploy['deploy_to']}/current/web-files/application/simplesaml" do
		to "#{deploy['deploy_to']}/current/web-files/simplesamlphp/www/"
	end

	# Create phpmyadmin symlink if needed
	link "#{deploy['deploy_to']}/current/web-files/application/phpmyadmin" do
		to "#{deploy['deploy_to']}/current/web-files/vendor/fillup/phpmyadmin-minimal"
	end

end
