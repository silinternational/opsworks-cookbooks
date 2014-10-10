# Additional setup tasks for development environment

#include_recipe "database::mysql"

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

    #mysql_database dbname do
    #  connection mysql_connection_info
    #  action :create
    #end
end

# Create database users
node['mysql']['users'].each do |dbusername, user|
    # Changed to manually create databases due to conflict for database cookbook 
    # and ospworks cookbooks
    execute "create user #{dbusername}" do
      command "mysql -u#{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h#{mysql_connection_info[:host]} -e \"grant all on #{user['database']}.* to \'#{dbusername}\'@\'localhost\' identified by \'#{user['password']}\';\""
    end

    #mysql_database_user dbusername do
    #    username dbusername
    #    password user['password']
    #     database_name user['database']
    #     privileges [:all]
    #     connection mysql_connection_info
    #     action [:create,:grant]
    # end
end

# Flush mysql privileges
execute "Flush mysql privileges" do
  command "mysql -u#{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h#{mysql_connection_info[:host]} -e 'flush privileges;'"
end

# Disable EnableSendFile in apache, needed when using vagrant on windows
# file "/etc/httpd/conf-available/sendfile.conf" do
#     owner "root"
#     group "root"
#     mode "0644"
#     content "EnableSendfile off"
#     action :create
#     notifies :restart, "service[apache2]", :immediately
# end
apache_conf "EnableSendFile" do
    enable true
    cookbook "apache2"
end