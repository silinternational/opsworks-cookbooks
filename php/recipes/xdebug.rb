# Install and configure xdebug

%w{php-devel php-pear gcc gcc-c++ autoconf automake}.each do |name|
	package name do
		action :install
	end
end

# Update pecl channel
php_pear_channel "pecl.php.net" do
    action :update
end

# install the xdebug pecl
php_pear "xdebug" do
  # Specify that xdebug.so must be loaded as a zend extension
  zend_extensions ['xdebug.so']
  action :install
end