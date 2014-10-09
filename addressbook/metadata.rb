name "addressbook"
description "Provides recipes for configuring Addressbook app"
license "MIT"
version "0.0.1"
maintainer "SIL International, GTIS"

recipe "addressbook::default", "Main application configuration and core dependencies"

depends "apache2"
depends "silphp"
depends "silapache2"
depends "simplesamlphp"