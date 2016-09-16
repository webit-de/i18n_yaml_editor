# frozen_string_literal: true
require 'rake/testtask'
require 'rubocop/rake_task'
require 'coveralls/rake/task'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
end

desc 'Run Coveralls'
Coveralls::RakeTask.new(:coverall)

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop)

task default: :test
