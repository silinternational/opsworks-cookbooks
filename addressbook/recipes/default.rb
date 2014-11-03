# Recipe installs and configures dependencies for Addressbook

# Required packages
case node[:platform_family]
  when 'rhel'
    packages = ["git", "httpd", "php", "php-mcrypt", "php-xml", "php-mbstring", "php-pdo"]
    apache_owner = "apache"
    apache_group = "apache"
  when 'debian'
    packages = ["git", "apache2", "php5", "php5-mcrypt", "php5-sqlite"]
    apache_owner = "www-data"
    apache_group = "www-data"
  end

packages.each do |name|
    package name do
        action :install
    end
end

# Configure apps
deploy = node['deploy']['addressbook']

# Update folder permissions
directory "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/application/protected/runtime" do
    owner apache_owner
    group apache_group
    group "apache"
    mode "0775"
    only_if { File.directory?("#{deploy['deploy_to']}#{deploy['aws_extra_path']}/application/protected") }
end
directory "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/application/public/assets" do
    owner apache_owner
    group apache_group
    mode "0775"
    only_if { File.directory?("#{deploy['deploy_to']}#{deploy['aws_extra_path']}/application/public") }
end

# Make sure yiic script is executable
file "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}/yiic" do
    owner "root"
    group "root"
    mode "0755"
    only_if { File.exists?("#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}/yiic") }
end

# Create simplesaml symlink if needed
link "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/application/public/simplesaml" do
    to "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/application/simplesamlphp/www/"
    only_if { File.directory?("#{deploy['deploy_to']}#{deploy['aws_extra_path']}/application/simplesamlphp/www/") }
end
