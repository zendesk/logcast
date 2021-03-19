require 'bundler/setup'
require 'bump/tasks'
require 'rake/testtask'
require 'bundler/gem_tasks' unless defined?(Bundler::GemfileError) # Workaround for https://github.com/thoughtbot/appraisal/issues/173
require 'appraisal'

task :default => ['test']

Rake::TestTask.new(:test) do |t|
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end
