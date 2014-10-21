# SIL Addition
# Recipe loops through node['deploy'] and creates ssl cert files from configuration
# as well as calls apache2 web_app function to create vhost entries

node['deploy'].each do |appname, deploy|
    # Put SSL cert files where they go
    if deploy['vhost']['ssl']['enabled']
        file "#{deploy['vhost']['ssl']['cert_path']}/#{deploy['vhost']['server_name']}.crt" do
            owner "root"
            group "root"
            mode "0644"
            action :create
            content deploy['vhost']['ssl']['cert_content']
            only_if { deploy['vhost']['ssl']['enabled'] && deploy['vhost']['ssl']['cert_content'] }
        end
        file "#{deploy['vhost']['ssl']['key_path']}/#{deploy['vhost']['server_name']}.key" do
            owner "root"
            group "root"
            mode "0600"
            action :create
            content deploy['vhost']['ssl']['key_content']
            only_if { deploy['vhost']['ssl']['enabled'] && deploy['vhost']['ssl']['key_content'] }
        end
        file "#{deploy['vhost']['ssl']['intermediate_cert_file']}" do
            owner "root"
            group "root"
            mode "0644"
            action :create
            content deploy['vhost']['ssl']['intermediate_cert_content']
            only_if { deploy['vhost']['ssl']['enabled'] && deploy['vhost']['ssl']['intermediate_cert_content'] }
        end
    end

    # Create vhost 
    web_app appname do
        server_name deploy['vhost']['server_name']
        server_aliases deploy['vhost']['server_aliases']
        docroot "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['vhost']['docroot']}"
        allow_override deploy['vhost']['allow_override']
        server_port deploy['vhost']['port']
        ssl_config deploy['vhost']['ssl']
    end
end
