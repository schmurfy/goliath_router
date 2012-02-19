#!/usr/bin/env rake

require 'bundler/setup'

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

task :default => [:unit, :integration]

desc "run unit tests"
RSpec::Core::RakeTask.new('unit') do |t|
  t.pattern = 'spec/unit/*_spec.rb'
end

desc "run integration tests"
RSpec::Core::RakeTask.new('integration') do |t|
  t.pattern = 'spec/integration/*_spec.rb'
end


desc 'Generate documentation'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', '-', 'LICENSE']
  t.options = ['--main', 'README.md', '--no-private']
end

