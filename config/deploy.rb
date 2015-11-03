# config valid only for current version of Capistrano
lock '3.4.0'

set :deploy_user, 'ricardo'
set :application, 'ranking_points'
set :repo_url, 'https://github.com/mesalva/ranking_points'

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :server_name, "localhost"

#server 'www.example.com', user: 'deploy', roles: %w{web app db}, primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

set :default_env, { rvm_bin_path: '~/.rvm/bin' }

set :rvm_type, :user                     # Defaults to: :auto

set :rvm_ruby_version, '2.2.1'      # Defaults to: 'default'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
#set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
#set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  p "============> aki antes"
  task :restart do
	  on roles(:app) do
	  	within "#{current_path}" do
	  		with rails_env: fetch(:rails_env) do
	  			run "/home/ricardo/.rvm/gems/ruby-2.2.1/gems/bundler-1.10.6/bin/bundle exec unicorn -p 3000"
	  		end
	  		
	  	end
	  	
		#execute "#{default_env}"	    
	  end
   end
end

#after 'deploy:restart', 'unicorn:restart'   # app preloaded
