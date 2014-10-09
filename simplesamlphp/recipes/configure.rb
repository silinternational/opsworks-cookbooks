node[:deploy].each do |application, deploy|
	if deploy[:simplesamlphp]
		file "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/cert/saml.crt" do
			content deploy[:simplesamlphp][:crt]
			owner deploy[:user]
    		group deploy[:group]
			mode 0664
		end

		file "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/cert/saml.pem" do
			content deploy[:simplesamlphp][:pem]
			owner deploy[:user]
    		group deploy[:group]
			mode 0664
		end

		# write out config/authsources.php
        template "#{deploy[:deploy_to]}#{deploy['aws_extra_path']}/#{deploy[:simplesamlphp][:path]}/config/authsources.php" do
            source 'config/authsources.php.erb'
            mode '0664'
            owner deploy[:user]
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
            owner deploy[:user]
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
            owner deploy[:user]
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