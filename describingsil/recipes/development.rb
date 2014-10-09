# Additional setup tasks for development environment

include_recipe "database::mysql"

# DB Connection info
mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

# Create databases
node['mysql']['dbs'].each do |dbname|
    mysql_database dbname do
      connection mysql_connection_info
      action :create
    end
end

# Create database users
node['mysql']['users'].each do |dbusername, user|
    mysql_database_user dbusername do
        username dbusername
        password user['password']
        database_name user['database']
        privileges [:all]
        connection mysql_connection_info
        action [:create,:grant]
    end
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
    cookbook "silapache2"
end