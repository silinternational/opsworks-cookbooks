define :update_composer, :self_update => true, :as_update => false do
  if params[:path]

    # Install composer.phar if not present
    execute "Installing composer.phar in #{params[:path]}" do
      user "root"
      command "cd #{params[:path]} && curl -sS https://getcomposer.org/installer | php"
      creates "#{params[:path]}/composer.phar"
    end

    # If self_update enabled, update composer.phar, unless it was just installed fresh
    if params[:self_update]
      execute "Performing self-update on Composer in #{params[:path]}" do
        user "root"
        command "cd #{params[:path]} && php composer.phar self-update"
      end
    end

    # Set github auth token to prevent hitting api rate limit
    if params[:github_token]
      execute "Setting github auth token for composer" do
        user "root"
        command "cd #{params[:path]} && php composer.phar config -g github-oauth.github.com #{params[:github_token]}"
      end
    end

    # Install globally required packages
    if ( params[:global_require] && params[:global_require].kind_of?(Array) )
      params[:global_require].each do |pkgname|
        execute "Installing composer globally required package: #{pkgname}" do
          user "root"
          command "cd #{params[:path]} && php composer.phar global require \"#{pkgname}\" "
        end
      end
    end

    # Install composer packages
    if params[:as_update]
      method = "update"
    else
      method = "install"
    end
    execute "Installing composer dependencies in #{params[:path]}" do
      user "root"
      command "cd #{params[:path]} && php composer.phar #{method}"
    end
  end
end
