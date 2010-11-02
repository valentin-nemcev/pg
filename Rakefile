# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

#Dir["#{Gem.searcher.find('thinking-sphinx').full_gem_path}/lib/tasks/*.rake"].each { |ext| load ext }

load Gem.searcher.find('thinking_sphinx').full_gem_path + "/tasks/rails.rake"
