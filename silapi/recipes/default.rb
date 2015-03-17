# Recipe installs and configures dependencies for silapi

# Required packages
case node[:platform_family]
  when 'rhel'
    packages = ["git", "httpd", "php", "php-mcrypt", "php-xml", "php-mbstring", "php-pdo", "php-mysql"]
    apache_owner = "apache"
    apache_group = "apache"
  when 'debian'
    packages = ["git", "apache2", "php5", "php5-mcrypt", "php5-mysql"]
    apache_owner = "www-data"
    apache_group = "www-data"
  end

packages.each do |name|
    package name do
        action :install
    end
end

# Configure apps
deploy = node['deploy']['silapi']

# Update folder permissions
folders = ["/application/protected/runtime","/application/public/assets"]
folders.each do |folder|
  directory "#{deploy['deploy_to']}#{deploy['aws_extra_path']}#{folder}" do
    owner apache_owner
    group apache_group
    mode "0775"
  end
end

# Make sure yiic script is executable
file "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}/yiic" do
    owner "root"
    group "root"
    mode "0755"
    only_if { File.exists?("#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}/yiic") }
end

