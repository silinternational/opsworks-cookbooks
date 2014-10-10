source "https://api.berkshelf.com"

def sil_cookbook(name, version = '>= 0.0.0', options = {})
  cookbook name, version, github: "silinternational/opsworks-cookbooks", rel: name, branch: "release-chef-11.10"
end

cookbook "yum",             github: "opscode-cookbooks/yum"
cookbook "yum-epel",        github: "opscode-cookbooks/yum-epel"
cookbook "perl",            github: "opscode-cookbooks/perl"
cookbook "mysql",           github: "opscode-cookbooks/mysql"
cookbook "hosts_file",      github: "hw-cookbooks/hosts_file"

sil_cookbook "gem_support"
sil_cookbook "opsworks_initial_setup"
sil_cookbook "dependencies"
sil_cookbook "opsworks_commons"
sil_cookbook "opsworks_nodejs"
sil_cookbook "deploy"
sil_cookbook "scm_helper"
sil_cookbook "ssh_users"
sil_cookbook "opsworks_agent_monit"
sil_cookbook "opsworks_java"
sil_cookbook "opsworks_aws_flow_ruby"
sil_cookbook "mod_php5_apache2"
sil_cookbook "apache2"
sil_cookbook "php"
sil_cookbook "simplesamlphp"
sil_cookbook "describingsil"

