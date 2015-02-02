# Run yii migrations
node['deploy'].each do |appname, deploy|
    if deploy['yii_dir']
        yii_migrate "yii_migrate" do
            if deploy['yii_ver']
                yii_ver deploy['yii_ver']
            else
                yii_ver 1
            end
            path "#{deploy['deploy_to']}#{deploy['aws_extra_path']}/#{deploy['yii_dir']}"
        end
    end
end