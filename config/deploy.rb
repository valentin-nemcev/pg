set :application, "polit-gramota"

set :deploy_to, "~/projects/#{application}"
set :rake, "/opt/ruby-enterprise-1.8.6-20090610/bin/rake" 

set :scm, :git
set :repository,  "git-vds:pg.git"
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :branch, "capistrano"
set :scm_verbose, false

set :use_sudo, false
set :ssh_options, { :forward_agent => true }

server 'pg-locum', :app, :web, :db


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end


  after "deploy:symlink", "deploy:symlink_shared_assets"
  task :symlink_shared_assets do
    %w{img files}.each do |share|
      run "ln -s #{current_path}/#{share} #{current_release}/public/#{share}"
    end
  end

  
end

# after "deploy:update", "gems:install"
namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    run "cd #{current_release} && #{try_sudo} #{rake} gems:install RAILS_ENV=production"
  end
end
