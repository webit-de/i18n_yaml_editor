require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
require 'minitest/hell'
require 'i18n_yaml_editor'

module Minitest
  class Test
    include I18nYamlEditor
    parallelize_me!
  end
end
