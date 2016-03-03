require 'test_helper'
require 'i18n_yaml_editor/store'

module TestStoreData
  def init_test_store_1
    store = I18nYamlEditor::Store.new
    store.add_translation tmp_translation_1
    store.locales.add('en')
    store
  end

  def init_test_store_0
    store = I18nYamlEditor::Store.new
    store.add_translation tmp_translation_0
    store.locales.add('en')
    store
  end

  def tmp_translation_1
    I18nYamlEditor::Translation.new(
      name: 'da.app_name', text: 'Oversætter', file: '/tmp/da.yml')
  end

  def tmp_translation_0
    I18nYamlEditor::Translation.new(
      name: 'da.session.login', text: 'Log ind', file: '/tmp/session.da.yml')
  end
end
