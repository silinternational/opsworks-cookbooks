# Recipe installs and configures dependencies for doorman

# Required packages
case node[:platform_family]
  when 'rhel'
    packages = ["git", "httpd", "php", "php-mcrypt", "php-xml", "php-mbstring", "php-pdo", "php-mysql", "nodejs", "npm"]
    apache_owner = "apache"
    apache_group = "apache"
  when 'debian'
    packages = ["git", "apache2", "php5", "php5-cli", "php5-mcrypt", "php5-mysql", "ruby-dev", "npm"]
    apache_owner = "www-data"
    apache_group = "www-data"
  end

packages.each do |name|
    package name do
        action :install
    end
end

# Configure apps
api = node['deploy']['doorman_api']

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
    command "#{api['deploy_to']}#{api['aws_extra_path']}/yii cron/send-emails"
end

# Setup Doorman UI
if node['deploy']['doorman_ui']
  
  ui = node['deploy']['doorman_ui']
  
  # Fix debian nodejs bug
  link "/usr/bin/node" do
    to "/usr/bin/nodejs"
  end

  execute "Doorman UI: gem install compass" do
    command "gem install compass"
    cwd "#{ui['deploy_to']}#{ui['aws_extra_path']}"
  end
  execute "Doorman UI: npm install" do
    command "npm install"
    user "root"
    cwd "#{ui['deploy_to']}#{ui['aws_extra_path']}"
  end
  execute "Doorman UI: npm install -g bower grunt-cli" do
    command "npm install -g bower grunt-cli"
    user "root"
    cwd "#{ui['deploy_to']}#{ui['aws_extra_path']}"
  end
  execute "Doorman UI: bower install" do
    command "bower install --allow-root"
    cwd "#{ui['deploy_to']}#{ui['aws_extra_path']}"
  end
  link "#{ui['deploy_to']}#{ui['aws_extra_path']}/app/bower_components" do
    to "#{ui['deploy_to']}#{ui['aws_extra_path']}/bower_components/"
  end
  link "#{ui['deploy_to']}#{ui['aws_extra_path']}/app/api" do
    to "#{api['deploy_to']}#{api['aws_extra_path']}/frontend/web/"
  end

end