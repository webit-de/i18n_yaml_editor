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
  puts "\nRunning Yardoc..."
  yard = `yard stats --list-undoc --compact`
  if yard =~ /Undocumented Objects/
    puts yard
    puts "\033[0;31mDocumentation coverage < 100%\nYardoc failed!\033[0m\n"
    exit 1
  else
    puts yard.each_line.to_a[0..-2]
    puts "\033[0;32m100.00% documented\033[0m\n\n\n"
  end
end

def capture_out
  captured_stdout = Tempfile.new('out')

  orig_stdout = $stdout.dup
  $stdout.reopen captured_stdout

  yield

  $stdout.rewind

  captured_stdout.read
ensure
  captured_stdout.unlink
  $stdout.reopen orig_stdout
end

def capture_err
  captured_stderr = Tempfile.new('err')

  orig_stderr = $stderr.dup
  $stderr.reopen captured_stderr

  yield

  $stderr.rewind

  captured_stderr.read
ensure
  captured_stderr.unlink
  $stderr.reopen orig_stderr
end

def capture_io
  require 'tempfile'
  err = nil
  out = capture_out do
    err = capture_err do
      yield
    end
  end

  [out, err]
end

task :coverage do
  out, = capture_io do
    envvars = 'SIMPLE_COV=true' unless ENV['TRAVIS']
    puts `#{envvars} bundle exec rake test`
  end
  puts out
  err = /\d+ tests, \d+ assertions, (\d+) failures, (\d+) errors, \d+ skips/
  unless out.scan(err).flatten.map(&:to_i).reduce(&:+).zero?
    puts "\nTest suite is not passing"
    exit 1
  end

  if out.lines.last =~ /LOC \(100\.0%\) covered/ ||
     out.lines[-2] =~ /Coverage is at 100\.0%/
    puts "\033[0;32m100.00% covered\033[0m\n\n"
  else
    puts "\n\033[0;31mCode coverage < 100%\033[0m\n"
    exit 1
  end
end

task default: [:coverage, :yardoc, :rubocop]
