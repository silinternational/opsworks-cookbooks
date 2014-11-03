# Install and configure xdebug

# Install required packages
case node[:platform_family]
  when 'rhel'
    packages = ["php-devel", "php-pear", "gcc", "gcc-c++", "autoconf", "automake"]
  when 'debian'
    packages = ["php5-xdebug"]
  end

packages.each do |name|
    package name do
        action :install
        notifies :reload, "service[apache2]", :delayed
    end
end

# RHEL and Debian systems ahve different install process
case node[:platform_family]
    when 'rhel'
        # Update pecl channel
        php_pear_channel "pecl.php.net" do
            action :update
        end

        # install the xdebug pecl
        php_pear "xdebug" do
          # Specify that xdebug.so must be loaded as a zend extension
          zend_extensions ['xdebug.so']
          options "--ignore-errors"
          action :install
          notifies :reload, "service[apache2]", :delayed
        end
    when 'debian'
        node['php']['directives'].merge(
            "zend_extension" => "/usr/lib/php5/20121212/xdebug.so",
            "xdebug.remote_enable" => "1",
            "xdebug.remote_handler" => "dbgp", 
            "xdebug.remote_mode" => "req",
            "xdebug.remote_host" => "127.0.0.1", 
            "xdebug.remote_port" => "9000"
        )

        include_recipe "php::ini"
end
