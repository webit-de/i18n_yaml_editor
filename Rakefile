# frozen_string_literal: true
require 'rake/testtask'
require 'rubocop/rake_task'
require 'coveralls/rake/task'
require 'capture_io/capture_io'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
end

desc 'Run Coveralls'
Coveralls::RakeTask.new(:coverall)

# Mixin
module RuboCop
  # Mixin
  class RakeTask
    private

    def run_cli(verbose, options)
      require 'rubocop'

      cli = CLI.new
      puts "\033[1;33m# Running RuboCop...\033[0m" if verbose
      result = cli.run(options)
      failed = result.nonzero? && fail_on_error
      abort("\033[0;31mRuboCop failed!\033[0m\n") if failed
      puts "\033[0;32mRuboCop passed\033[0m\n\n\n"
    end
  end
end

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop)

desc 'Generate documentation in doc/ and check documentation coverage'
task :yardoc do
  require 'yard'
  puts "\n\033[1;33m# Running Yardoc...\033[0m"
  yard = `yard stats --list-undoc --compact`
  if yard =~ /Undocumented Objects/
    puts yard
    puts "\033[0;31mYardoc failed - documentation coverage < 100%\033[0m\n"
    exit 1
  else
    puts yard.each_line.to_a[0..-2]
    puts "\033[0;32mYardoc passed - 100.00% documented\033[0m\n\n\n"
  end
end

task :coverage do
  puts "\033[1;33m# Running Minitest...\033[0m"
  out, = capture_io do
    envvars = 'SIMPLE_COV=true' unless ENV['TRAVIS']
    puts `#{envvars} bundle exec rake test`
  end
  puts out
  err = /\d+ tests, \d+ assertions, (\d+) failures, (\d+) errors, \d+ skips/
  unless out.scan(err).flatten.map(&:to_i).reduce(&:+).zero?
    puts "\n\033[0;31mMinitest failed\033[0m\n"
    exit 1
  end

  if out.lines.last =~ /LOC \(100\.0%\) covered/ ||
     out.lines[-2] =~ /Coverage is at 100\.0%/
    puts "\033[0;32mMinitest passed - 100.00% covered\033[0m\n\n"
  else
    puts "\n\033[0;31mMinitest failed - Code coverage < 100%\033[0m\n"
    exit 1
  end
end

task default: [:coverage, :yardoc, :rubocop] do
  puts "\033[0;32mYAY! - Translator test suite passed\033[0m\n\n"
end
