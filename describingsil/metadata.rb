name "describingsil"
description "Provides recipes for configuring Describing SIL app"
license "MIT"
version "0.0.1"
maintainer "SIL International, GTIS"

recipe "describingsil::default", "Main application configuration and core dependencies"
recipe "describingsil::development", "Additional setup tasks for development environment"

depends "apache2"
depends "php"
depends "simplesamlphp"