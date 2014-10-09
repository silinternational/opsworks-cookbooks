name "mailadmin"
description "Provides recipes for configuring Mail Admin"
license "MIT"
version "0.0.1"
maintainer "SIL International, GTIS"

recipe "mailadmin::default", "Main application configuration and core dependencies"
recipe "mailadmin::openldap", "Highly custom openldap setup for dev/test environment"

depends "apache2"
depends "mysql-chef_gem"
depends "database"
depends "application"