# mysql db backup and restore for rails
# by David Lowenfels <david@internautdesign.com> 4/2011

require 'yaml'

namespace 'db:data' do

  def get_dump_dir
    File.join(RAILS_ROOT, 'db', 'dumps')
  end

  def get_db_params_for op
    db = YAML::load( File.open( File.join(RAILS_ROOT, 'config', 'database.yml') ) )[ RAILS_ENV ]
    params = []
    if op == :dump && db['has_mysql_double_utf8_bug']
      params << " --default-character-set=latin1 --skip-set-charset"
    else
      params << " --default-character-set=#{db['encoding']}" unless db['encoding'].blank?
    end
    params << "-h#{db['host']}" unless db['host'].blank?
    params << "-u#{db['username']}" unless db['username'].blank?
    params << "-p#{db['password']}" unless db['password'].blank?
    params << "#{db['database']}"
    params.join(' ')
  end

  desc 'Backup database by mysqldump'
  task :dump => :environment do
    directory = get_dump_dir
    db_params = get_db_params_for :dump
    FileUtils.mkdir directory unless File.exists?(directory)
    schema_version = ActiveRecord::Migrator.current_version
    basename = [RAILS_ENV, DateTime.now, schema_version].join('_')
    file = File.join( directory, "#{basename}.sql" )
    command = "mysqldump #{db_params} | gzip > #{file}.gz" #--opt --skip-add-locks
    puts "dumping to #{file}..."
    puts command
    exec command
  end

  desc "restore most recent mysqldump (from db/dumps/*.sql.*) into the current environment's database."
  task :load => :environment do
    unless RAILS_ENV=='development'
      puts "Are you sure you want to import into #{RAILS_ENV}?! [y/N]"
      return unless STDIN.gets =~ /^y/i
    end
    directory = get_dump_dir
    db_params = get_db_params_for :load
    wildcard = File.join( directory, ENV['FILE'] || "#{ENV['FROM']}*.sql*" )
    file = `ls -t #{wildcard} | head -1`.chomp # default to file, or most recent ENV['FROM'] or just plain most recent
    if file =~ /\.gz(ip)?$/
      command = "gunzip < #{file} | mysql #{db_params}"
    else
      command = "mysql #{db_params} < #{file}"
    end
    puts "loading from #{file}..."
    puts command
    exec command
  end

end
