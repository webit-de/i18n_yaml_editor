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

desc 'Generate documentation in doc/ and check documentation coverage'
task :yardoc do
  require 'yard'
  `yard`
  puts yard = `yard stats --list-undoc --compact`
  if yard =~ /Undocumented Objects/
    puts "\n\nDocumentation coverage < 100%"
    puts 'Yardoc failed!'
    exit 1
  end
end

task default: [:test, :yardoc, :rubocop]
