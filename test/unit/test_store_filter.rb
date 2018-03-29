# frozen_string_literal: true

require 'test_helper'
require 'i18n_yaml_editor/store'

class TestStore < Minitest::Test
  def test_filter_keys_on_key
    store = Store.new
    store.add_key(Key.new(name: 'session.login'))
    store.add_key(Key.new(name: 'session.logout'))

    result = store.filter_keys(key: /login/)

    assert_equal 1, result.size
    assert_equal %w[session.login], result.keys
  end

  def test_filter_keys_on_complete
    store = Store.new
    [{ name: 'da.session.login', text: 'Log ind' },
     { name: 'en.session.login' },
     { name: 'da.session.logout', text: 'Log ud' }].each do |translation|
      store.add_translation Translation.new(translation)
    end

    result = store.filter_keys(complete: false)

    assert_equal 1, result.size
    assert_equal %w[session.login], result.keys
  end

  def test_filter_keys_on_empty
    store = Store.new
    store.add_translation Translation.new(name: 'da.session.login',
                                          text: 'Log ind')
    store.add_translation Translation.new(name: 'da.session.logout')

    result = store.filter_keys(empty: true)

    assert_equal 1, result.size
    assert_equal %w[session.logout], result.keys
  end

  def test_filter_keys_on_text
    store = Store.new
    store.add_translation Translation.new(name: 'da.session.login',
                                          text: 'Log ind')
    store.add_translation Translation.new(name: 'da.session.logout',
                                          text: 'Log ud')
    store.add_translation Translation.new(name: 'da.app.name',
                                          text: 'I18n Yaml Editor')

    result = store.filter_keys(text: /Log/)

    assert_equal 2, result.size
    assert_equal %w[session.login session.logout].sort, result.keys.sort
  end
end
