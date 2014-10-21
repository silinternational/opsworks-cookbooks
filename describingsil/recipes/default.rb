# Recipe installs and configures dependencies for describingsil

# Required packages
packages = ["git", "httpd", "php", "php-mcrypt", "php-xml", "php-mbstring", "php-pdo", "php-mysql"]

packages.each do |name|
    package name do
        action :install
    end
end

# Configure apps
deploy = node['deploy']['desc_sil_app']

# Update folder permissions
directory "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/protected/runtime" do
    owner "apache"
    group "apache"
    mode "0775"
end
directory "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/public/assets" do
    owner "apache"
    group "apache"
    mode "0775"
end

# Make sure yiic script is executable
file "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}/yiic" do
    owner "root"
    group "root"
    mode "0755"
end

# Create simplesaml symlink if needed
link "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/public/simplesaml" do
    to "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/simplesamlphp/www/"
end


