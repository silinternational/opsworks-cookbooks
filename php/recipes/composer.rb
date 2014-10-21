# Update composer dependencies
node['deploy'].each do |appname, deploy|
    if ( deploy['composer'] && deploy['composer'].is_a?(::Hash) )
        update_composer do
            path "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['composer']['dir']}"
            self_update deploy['composer']['self_update']
            as_update deploy['composer']['as_update']
            only_if { File.exists?("#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['composer']['dir']}/composer.json") }
        end
    end
end