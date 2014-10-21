node['deploy'].each do |application, deploy|

  if (deploy['config_files'] && deploy['config_files'].is_a?(::Hash))
    deploy['config_files'].each do |file, data|
      template "config file #{data['filename']}" do
        source 'array.php.erb'
        path "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['config_path']}/#{data['filename']}"
        mode '0664'
        owner deploy['owner']
        group deploy['group']
        variables(
          :data => Silphp::Helper.hash_to_array(data['content']),
        )
      end

    end
    
  end

end