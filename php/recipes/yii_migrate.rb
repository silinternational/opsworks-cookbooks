# Run yii migrations
node['deploy'].each do |appname, deploy|
    yii_migrate "yii_migrate" do
        path "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}"
        only_if { File.exists?("#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}/yiic") }
    end
end