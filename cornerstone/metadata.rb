name "cornerstone"
description "Provides recipes for configuring Cornerstone sync app"
license "MIT"
version "0.0.1"
maintainer "SIL International, GTIS"

recipe "cornerstone::default", "Main application configuration and core dependencies"
recipe "cornerstone::development", "Additional setup tasks for development environment"

depends "apache2"
depends "php"
depends "simplesamlphp"