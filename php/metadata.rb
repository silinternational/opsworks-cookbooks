name        "php"
description "Installs PHP"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.0.0"

recipe "php::configure", "Configure script to create php arrays out of provided JSON"
recipe "php::xdebug", "Install and enable xdebug in PHP, primarily used in dev environments"
recipe "php::composer", "Install composer.phar if needed, run self-update on composer, and install composer dependencies for each deploy application"
recipe "php::yii_migrate", "Execute yiic migrate --interactive=0 for each deploy application"
recipe "php::ini", "Create/configure php.ini"

depends "deploy"
