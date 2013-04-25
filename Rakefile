require 'bundler/setup'
require 'bump/tasks'
require 'rake/testtask'
require 'bundler/gem_tasks'
require 'appraisal'

desc 'Test the logcast plugin.'
Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end

desc 'Default: run unit tests.'
task :default do
  sh "rake appraisal:install && rake appraisal test"
end
