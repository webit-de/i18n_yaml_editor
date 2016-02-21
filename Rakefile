require 'rake/testtask'
require 'coveralls/rake/task'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
end

Coveralls::RakeTask.new

task default: :test
