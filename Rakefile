require 'bundler/setup'
require 'bump/tasks'
require 'rake/testtask'
require 'bundler/gem_tasks'
require 'appraisal'

task :default => ['test']

Rake::TestTask.new(:test) do |t|
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end
