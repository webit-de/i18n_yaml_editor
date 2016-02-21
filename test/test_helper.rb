require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
require 'i18n_yaml_editor'

module Minitest
  class Test
    include I18nYamlEditor
  end
end
