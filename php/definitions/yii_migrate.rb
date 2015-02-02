define :yii_migrate do 
	if params[:path]
		execute "Running yii migrations in #{params[:path]}" do
			user "root"
            if params[:dbname]
                dbname = params[:dbname]
            else
                dbname = "db"
            end
            if params[:yii_ver] == 2
                command "#{params[:path]}/yii migrate --interactive=0 --db=#{dbname}"
            else
			    command "#{params[:path]}/yiic migrate --interactive=0 --connectionID=#{dbname}"
            end
		end
	end
end