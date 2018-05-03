# frozen_string_literal: true

# I18n Yaml Editor
module I18nYamlEditor
  class << self
    attr_accessor :app
  end
end

require 'i18n_yaml_editor/app'
require 'i18n_yaml_editor/category'
require 'i18n_yaml_editor/key'
require 'i18n_yaml_editor/store'
require 'i18n_yaml_editor/translation'
require 'i18n_yaml_editor/web'
