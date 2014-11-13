node[:deploy].each do |application, deploy|
    if deploy[:simplesamlphp]
        # Figure out AWS credentials if available
        access_key_id = deploy[:aws][:access_key_id] || node[:aws][:access_key_id] || false
        secret_access_key = deploy[:aws][:secret_access_key] || node[:aws][:secret_access_key] || false
        s3_bucket = deploy[:aws][:s3_bucket] || node[:aws][:s3_bucket] || false

        # Create CRT and PEM files from JSON content if available
        if deploy[:simplesamlphp][:crt]
            file "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/cert/saml.crt" do
                content deploy[:simplesamlphp][:crt]
                owner deploy[:owner]
                group deploy[:group]
                mode 0664
            end
        end
        if deploy[:simplesamlphp][:pem]
            file "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/cert/saml.pem" do
                content deploy[:simplesamlphp][:pem]
                owner deploy[:owner]
                group deploy[:group]
                mode 0664
            end
        end

        # Create CRT and PEM files from S3 if configuration available
        if deploy[:simplesamlphp][:s3_crt_path] && access_key_id && secret_access_key && s3_bucket
            s3_file "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/cert/saml.crt" do
                aws_access_key_id access_key_id
                aws_secret_access_key secret_access_key
                remote_path deploy[:simplesamlphp][:s3_crt_path]
                bucket s3_bucket
                owner deploy[:owner]
                group deploy[:group]
                mode 0664
                action :create
            end
        end
        if deploy[:simplesamlphp][:s3_pem_path] && access_key_id && secret_access_key && s3_bucket
            s3_file "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/cert/saml.pem" do
                aws_access_key_id access_key_id
                aws_secret_access_key secret_access_key
                remote_path deploy[:simplesamlphp][:s3_pem_path]
                bucket s3_bucket
                owner deploy[:owner]
                group deploy[:group]
                mode 0664
                action :create
            end
        end

        # write out config/authsources.php
        template "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/config/authsources.php" do
            source 'config/authsources.php.erb'
            mode '0664'
            owner deploy[:owner]
            group deploy[:group]
            variables(
              :data => deploy[:simplesamlphp][:authsources],
            )
            only_if do
              File.exists?("#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/config")
            end
        end

        # write out config/config.php
        template "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/config/config.php" do
            source 'config/config.php.erb'
            mode '0664'
            owner deploy[:owner]
            group deploy[:group]
            variables(
              :data => deploy[:simplesamlphp][:config],
            )
            only_if do
              File.exists?("#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/config")
            end
        end

        # write out metadata/saml20-idp-remote.php
        template "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/metadata/saml20-idp-remote.php" do
            source 'metadata/saml20-idp-remote.php.erb'
            mode '0664'
            owner deploy[:owner]
            group deploy[:group]
            variables(
              :data => deploy[:simplesamlphp][:metadata],
            )
            only_if do
              File.exists?("#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/metadata")
            end
        end
    end
end
