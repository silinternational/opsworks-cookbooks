# Additional setup tasks for development environment

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