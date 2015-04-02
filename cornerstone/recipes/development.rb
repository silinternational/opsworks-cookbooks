# Disable SendFile in apache, fixes issues in vagrant environments
apache_conf "EnableSendFile" do
    enable true
    cookbook "apache2"
end

deploy = node['deploy']['cornerstone_sync']

# Initialize Codeception
# execute "Bootstrap Codeception" do
#   command "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/vendor/bin/codecept bootstrap"
# end 
# execute "Build Codeception" do
#   command "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/vendor/bin/codecept build"
# end 