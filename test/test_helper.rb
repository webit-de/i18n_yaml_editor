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
require 'i18n_yaml_editor'

module Minitest
  class Test
    include I18nYamlEditor
    parallelize_me!
  end
end
