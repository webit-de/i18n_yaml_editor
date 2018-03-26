# frozen_string_literal: true

$VERBOSE = nil

require 'simplecov'
SimpleCov.start do
  add_filter '/test'
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
