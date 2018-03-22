# frozen_string_literal: true

$VERBOSE = nil

if ENV['SIMPLE_COV']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test'
  end
else
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
require 'minitest/hell'
require 'minitest/reporters'
require 'rack/test'
require 'translator'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

module Minitest
  class Test
    include Translator
    parallelize_me!
  end
end
