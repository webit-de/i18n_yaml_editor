# frozen_string_literal: true
require 'test_helper'
require 'unit/test_store_data'
require 'i18n_yaml_editor/store'

class TestStore < Minitest::Test
  include TestStoreData

  attr_accessor :input, :expected_yaml

  TEST_DATA = {
    '/tmp/session.da.yml' => {
      da: { session: { login: 'Log ind', logout: 'Log ud' } }
    },
    '/tmp/session.en.yml' => {
      en: { session: { login: 'Sign in' } }
    },
    '/tmp/da.yml' => {
      da: { app_name: 'Oversætter' }
    }
  }.freeze

  def initialize(*)
    self.input = {
      da: { session: { login: 'Log ind' } }
    }

    self.expected_yaml = TEST_DATA.with_indifferent_access
    super
  end

  def test_add_translations_store_translations
    store = Store.new
    translation = Translation.new(name: 'da.session.login')

    store.add_translation(translation)

    assert_equal 1, store.translations.size
    assert_equal translation, store.translations[translation.name]
  end

  def test_add_translations_store_keys
    store = Store.new
    translation = Translation.new(name: 'da.session.login')

    store.add_translation(translation)

    assert_equal 1, store.keys.size
    assert_equal [translation].to_set, store.keys['session.login'].translations
  end

  def test_add_translations_store_categories
    store = Store.new
    translation = Translation.new(name: 'da.session.login')

    store.add_translation(translation)

    assert_equal 1, store.categories.size
    assert_equal %w(session.login), store.categories['session'].keys.map(&:name)
  end

  def test_add_translations_store_locales
    store = Store.new
    translation = Translation.new(name: 'da.session.login')

    store.add_translation(translation)

    assert_equal 1, store.locales.size
    assert_equal %w(da), store.locales.to_a
  end

  def test_add_duplicate_translation
    store = Store.new
    t1 = Translation.new(name: 'da.session.login')
    t2 = Translation.new(name: 'da.session.login')
    store.add_translation(t1)

    assert_raises(DuplicateTranslationError) do
      store.add_translation(t2)
    end
  end

  def test_create_missing_translations
    store = init_test_store_0

    store.create_missing_keys

    assert(translation = store.translations['en.session.login'])
    assert_equal 'en.session.login', translation.name
    assert_equal '/tmp/session.en.yml', translation.file
    assert_nil translation.text
  end

  def test_create_missing_translations_in_top_level_file
    store = init_test_store_1

    store.create_missing_keys

    assert(translation = store.translations['en.app_name'])
    assert_equal 'en.app_name', translation.name
    assert_equal '/tmp/en.yml', translation.file
    assert_nil translation.text
  end

  def test_from_yaml
    store = Store.new

    store.from_yaml(input)

    assert_equal 1, store.translations.size
    translation = store.translations['da.session.login']
    assert_equal 'da.session.login', translation.name
    assert_equal 'Log ind', translation.text
  end

  def test_to_yaml
    store = Store.new
    store.add_translation Translation.new(
      name: 'da.session.login', text: 'Log ind', file: '/tmp/session.da.yml')
    store.add_translation Translation.new(
      name: 'en.session.login', text: 'Sign in', file: '/tmp/session.en.yml')
    store.add_translation Translation.new(
      name: 'da.session.logout', text: 'Log ud', file: '/tmp/session.da.yml')
    store.add_translation Translation.new(
      name: 'da.app_name', text: 'Oversætter', file: '/tmp/da.yml')

    assert_equal @expected_yaml, store.to_yaml
  end
end
