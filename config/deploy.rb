

set :application, "polit-gramota"

require 'bundler/capistrano'
# set :bundle_flags,    "--deployment --quiet"
set :bundle_flags,    "--deployment"

set :scm, :git
set :repository,  "git@vds:pg.git"
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

  $:.unshift(File.expand_path('./lib', ENV['rvm_path']))
  logger.debug File.expand_path('./lib', ENV['rvm_path'])
  require "rvm/capistrano"
  set :rvm_ruby_string, 'ruby-1.8.7-p352@polit-gramota'

end


set :shared_assets, %w{img files}

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end


  after "deploy:update", "deploy:symlink_shared_assets"
  desc "Symlinks shared assets"
  task :symlink_shared_assets do
    shared_assets.each do |share|
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


namespace :sync do
  desc "Sync remote assets and database to local"
  task :local do
    path = 'db/dumps/'
    server = roles[:web].servers.first.host
    run "cd #{current_path} && bundle exec rake db:data:dump", :env => {'RAILS_ENV' => rails_env}
    system "rsync --progress --human-readable --recursive --update #{server}:#{current_path}/#{path} #{path}"
    system "bundle exec rake db:data:load"
    shared_assets.each do |share|
      system "rsync --progress --human-readable --recursive --update #{server}:#{shared_path}/#{share}/ public/#{share}"
    end
  end
end
