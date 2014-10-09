# Run yii migrations
node['deploy'].each do |appname, deploy|
    yii_migrate "yii_migrate" do
        path "#{deploy['deploy_to']}/#{deploy['yii_dir']}"
    end
end