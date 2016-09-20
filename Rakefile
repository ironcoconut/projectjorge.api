require 'yaml'
require 'rake/testtask'

task :console do 
  exec %{pry -r './scripts/load_lib.rb'}
end

task :neo4j do
  exec %{sudo service neo4j restart}
end

task :neo4j_test do
  exec %{NEO4J_CONF=/home/ironcoconut/.neo4j/test neo4j start}
end

task :start do
  exec 'rackup -p 4201'
end

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end
