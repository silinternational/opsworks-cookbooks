# Custom recipe to setup openldap for local development environments

# Required packages
packages = ["openldap-servers", "openldap-clients"]

packages.each do |name|
    package name do
        action :install
    end
end

# Update ldap.conf to set localhost as URI and disable validating certs
bash "update ldap.conf" do
    user "root"
    code <<-EOH
    if grep -q "#URI" /etc/openldap/ldap.conf; then
        sudo sed -i "s/^#URI.*$/URI ldap:\/\/localhost:389/" /etc/openldap/ldap.conf
        sudo bash -c 'echo "TLS_REQCERT never" >> /etc/openldap/ldap.conf'
    fi
    EOH
    action :run
end

# Delete /etc/openldap/slapd.d/ folder if exists
directory "/etc/openldap/slapd.d" do
    recursive true
    action :delete
end

# Load slapd.conf
template 'slapd.conf' do
    path "/etc/openldap/slapd.conf"
    source "slapd.conf.erb"
    owner "ldap"
    group "ldap"
    mode 0644
end

# Load custom schemas
template 'gisGroup.schema' do
    path "/etc/openldap/schema/gisGroup.schema"
    source "gisGroup.schema.erb"
    owner "ldap"
    group "ldap"
    mode 0644
end
template 'gisPerson.schema' do
    path "/etc/openldap/schema/gisPerson.schema"
    source "gisPerson.schema.erb"
    owner "ldap"
    group "ldap"
    mode 0644
end
template 'ldaproute.schema' do
    path "/etc/openldap/schema/ldaproute.schema"
    source "ldaproute.schema.erb"
    owner "ldap"
    group "ldap"
    mode 0644
end

# Create LDAP database directories
directory "/var/db/openldap" do
    owner "ldap"
    group "ldap"
    mode 0700
    recursive true
    action :create
end
directory "/var/db/openldap/master-ldap" do
    owner "ldap"
    group "ldap"
    mode 0700
    recursive true
    action :create
end
directory "/var/db/openldap/rep-ldap" do
    owner "ldap"
    group "ldap"
    mode 0700
    recursive true
    action :create
end

# Start slapd service
service "slapd" do
    supports :status => true, :restart => true
    action [ :enable, :start ]
end

# Load ldifs
template 'fakemaster.ldif' do
    path "/etc/openldap/fakemaster.ldif"
    source "fakemaster.ldif.erb"
    owner "ldap"
    group "ldap"
    mode 0644
end
template 'fakerep.ldif' do
    path "/etc/openldap/fakerep.ldif"
    source "fakerep.ldif.erb"
    owner "ldap"
    group "ldap"
    mode 0644
end

bash "load ldifs" do
    user "root"
    code <<-EOH
    sleep 5
    sudo ldapadd -f /etc/openldap/fakemaster.ldif -D cn=Manager,o=wsfo -w password -H ldap://localhost:389
    sudo ldapadd -f /etc/openldap/fakerep.ldif -D cn=sysadmin,dc=insitehome,dc=org -w password -H ldap://localhost:389
    EOH
    returns [0, 68]
    action :run
end
