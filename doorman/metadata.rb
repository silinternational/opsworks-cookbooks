name "doorman"
description "Provides recipes for configuring Doorman app"
license "MIT"
version "0.0.1"
maintainer "SIL International, GTIS"

recipe "doorman::default", "Main application configuration and core dependencies"
recipe "doorman::development", "Additional setup tasks for development environment"

depends "apache2"
depends "php"
depends "simplesamlphp"