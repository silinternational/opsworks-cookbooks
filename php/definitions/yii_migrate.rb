define :yii_migrate do 
	if params[:path]
		execute "Running yii migrations in #{params[:path]}" do
			user "root"
			command "#{params[:path]}/yiic migrate --interactive=0"
		end
	end
end