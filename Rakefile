require 'rubygems'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = FileList['notifier_test.rb']
  t.verbose = true
end