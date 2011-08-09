

set :application, "polit-gramota"

require 'bundler/capistrano'


set :scm, :git
set :repository,  "git-vds:pg.git"
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :branch, "master"
set :scm_verbose, false
set :use_sudo, false
set :ssh_options, { :forward_agent => true }



desc "Config for locum shared hosting"
task :locum do
  server 'pg-locum', :app, :web, :db
  set :deploy_to, "~/projects/#{application}"
  set :rake, "/opt/ruby-enterprise-1.8.6-20090610/bin/rake"

  set :default_environment, {
    'PATH' => '/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/X11R6/bin:/$HOME/.gem/ruby/1.8/bin:/var/lib/gems/1.8/bin',
    'GEM_PATH' =>  "/var/lib/gems/1.8:/home/hosting_zlob-o-zlob/.gem/ruby/1.8" #"`gem env gempath`"
  }
end

desc "Config for linode vds"
task :linode do
  server 'pg-linode-vds', :app, :web, :db
  set :deploy_to, "~/projects/#{application}"
end



namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end


  after "deploy:update", "deploy:symlink_shared_assets"
  desc "Symlinks shared assets"
  task :symlink_shared_assets do
    %w{img files}.each do |share|
      run "cd #{current_path} && ln -s #{shared_path}/#{share} public/#{share}"
    end
  end

  after 'deploy:update_code', 'deploy:symlink_db'
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end


end

# after "deploy:update", "gems:install"
namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    run "cd #{current_release} && #{try_sudo} #{rake} -f #{current_release}/Rakefile  gems RAILS_ENV=production"
  end
end
