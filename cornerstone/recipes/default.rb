# Recipe installs and configures dependencies for doorman

# Required packages
case node[:platform_family]
  when 'rhel'
    packages = ["git", "httpd", "php", "php-mcrypt", "php-xml", "php-mbstring", "openssh-clients"]
    apache_owner = "apache"
    apache_group = "apache"
  when 'debian'
    packages = ["git", "apache2", "php5", "php5-cli", "openssh-client"]
    apache_owner = "www-data"
    apache_group = "www-data"
  end

packages.each do |name|
    package name do
        action :install
    end
end

# Configure apps
app = node['deploy']['cornerstone_sync']

case node[:platform_family]
    when 'debian'
        execute "enable php5-mcrypt extension" do
            command "php5enmod mcrypt"
            notifies :reload, "service[apache2]", :delayed
        end
    end

# Update folder permissions
folders = ["/runtime","/data-temp"]
folders.each do |folder|
  directory "#{app['deploy_to']}#{app['aws_extra_path']}#{folder}" do
    owner apache_owner
    group apache_group
    mode "0775"
  end
end

# Add cron jobs
cron "insite2cornerstone_queue" do
    minute '*/5'
    command "#{app['deploy_to']}#{app['aws_extra_path']}/yii cron/insite-to-cornerstone"
end
