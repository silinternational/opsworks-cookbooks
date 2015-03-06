# Recipe installs and configures dependencies for doorman

# Required packages
case node[:platform_family]
  when 'rhel'
    packages = ["git", "httpd", "php", "php-mcrypt", "php-xml", "php-mbstring", "php-pdo", "php-mysql"]
    apache_owner = "apache"
    apache_group = "apache"
  when 'debian'
    packages = ["git", "apache2", "php5", "php5-cli", "php5-mcrypt", "php5-mysql"]
    apache_owner = "www-data"
    apache_group = "www-data"
  end

packages.each do |name|
    package name do
        action :install
    end
end

# Configure apps
deploy = node['deploy']['doorman_api']

case node[:platform_family]
    when 'debian'
        execute "enable php5-mcrypt extension" do
            command "php5enmod mcrypt"
            notifies :reload, "service[apache2]", :delayed
        end
    end

# Add cron job to process email queue
cron "email_queue" do
    minute '*/5'
    command "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/yii cron/send-emails"
end