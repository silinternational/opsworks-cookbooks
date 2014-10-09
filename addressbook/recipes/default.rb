# Recipe installs and configures dependencies for Addressbook

# Required packages
packages = ["git", "httpd", "php", "php-mcrypt", "php-xml", "php-mbstring", "php-pdo"]

packages.each do |name|
    package name do
        action :install
    end
end

# Configure apps
node['deploy'].each do |appname, deploy|

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

    # Create simplesaml symlink if needed
    link "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/public/simplesaml" do
        to "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/simplesamlphp/www/"
    end

end
