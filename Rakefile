require 'yaml'
require 'rake/testtask'

task :console do 
  exec 'irb -r ./lib/index.rb'
end

task :start do
  exec 'rackup -p 4000'
end

task :env do
  @env = YAML::load_file(File.join(__dir__, './config/database.yml'))['development']
end

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end
