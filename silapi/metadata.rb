name "silapi"
description "Provides recipes for configuring Developer Portal"
license "MIT"
version "0.0.1"
maintainer "SIL International, GTIS"

recipe "silapi::default", "Main application configuration and core dependencies"
recipe "silapi::development", "Additional setup tasks for development environment"

depends "apache2"
depends "php"
depends "simplesamlphp"