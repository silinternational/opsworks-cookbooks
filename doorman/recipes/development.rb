# Additional setup tasks for development environment

# Additional packages
case node[:platform_family]
  when 'rhel'
    packages = ["mysql-client", "mysql-server", "nodejs", "npm"]
    apache_owner = "apache"
    apache_group = "apache"
  when 'debian'
    packages = ["mysql-client", "mysql-server", "ruby-dev", "npm"]
    apache_owner = "www-data"
    apache_group = "www-data"
  end

packages.each do |name|
    package name do
        action :install
    end
end

# DB Connection info
mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

# Create databases
node['mysql']['dbs'].each do |dbname|
    # Changed to manually create databases due to conflict for database cookbook 
    # and ospworks cookbooks
    execute "create database #{dbname}" do
      command "mysql -u#{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h#{mysql_connection_info[:host]} -e 'create database if not exists #{dbname};'"
    end
end

# Create database users
node['mysql']['users'].each do |dbusername, user|
    # Changed to manually create databases due to conflict for database cookbook 
    # and ospworks cookbooks
    user['databases'].each do |dbname|
        execute "create user #{dbusername} on #{dbname}" do
            command "mysql -u#{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h#{mysql_connection_info[:host]} -e \"grant all on #{dbname}.* to \'#{dbusername}\'@\'localhost\' identified by \'#{user['password']}\';\""
        end
    end
end

# Flush mysql privileges
execute "Flush mysql privileges" do
  command "mysql -u#{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h#{mysql_connection_info[:host]} -e 'flush privileges;'"
end

# Disable SendFile in apache, fixes issues in vagrant environments
apache_conf "EnableSendFile" do
    enable true
    cookbook "apache2"
end

# Also run migrations on the test database (if applicable).
if node['deploy']['doorman_api']['config_files']['common_main_local']['content']['components']['testDb']
    deploy = node['deploy']['doorman_api']
    if File.exists?("#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}/yii")
        yii_migrate "yii_migrate on testDb" do
            yii_ver 2
            dbname "testDb"
            path "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}"
        end
    end
end

# Initialize Codeception
execute "Bootstrap Codeception" do
  command "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/vendor/bin/codecept bootstrap"
end 
execute "Build Codeception" do
  command "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/vendor/bin/codecept build"
end 
