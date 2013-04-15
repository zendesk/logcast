require 'rake'
require 'rake/testtask'
require 'bundler/gem_tasks'
require 'appraisal'

desc 'Test the rails_logcast plugin.'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end

desc 'Default: run unit tests.'
task :default do
  sh "bundle exec rake appraisal:install && bundle exec rake appraisal test"
end
