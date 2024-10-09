# frozen_string_literal: true

require 'test_helper'
require 'i18n_yaml_editor/key'

class TestKey < Minitest::Test
  def test_category
    key = Key.new(name: 'session.login')
    assert_equal 'session', key.category
  end

  def test_complete_with_text_for_all_translations
    key = Key.new(name: 'session.login')
    key.add_translation Translation.new(name: 'da.session.login',
                                        text: 'Log ind')
    key.add_translation Translation.new(name: 'en.session.login',
                                        text: 'Sign in')

    assert key.complete?
  end

  def test_complete_with_no_texts
    key = Key.new(name: 'session.login')
    key.add_translation Translation.new(name: 'da.session.login')
    key.add_translation Translation.new(name: 'en.session.login')

    assert key.complete?
  end

  def test_not_complete_without_text_for_some_translations
    key = Key.new(name: 'session.login')
    key.add_translation Translation.new(name: 'da.session.login',
                                        text: 'Log ind')
    key.add_translation Translation.new(name: 'en.session.login')

    assert_equal false, key.complete?
  end

  def test_emptycomplete_with_no_texts
    key = Key.new(name: 'session.login')
    key.add_translation Translation.new(name: 'da.session.login')
    key.add_translation Translation.new(name: 'en.session.login')

    assert key.empty?
  end

  def test_varinconsistent
    key = Key.new(name: 'session.login')
    key.add_translation Translation.new(name: 'en.session.login')
    key.add_translation Translation.new(name: 'da.session.login',
                                        text: 'Log ind')
    assert_equal false, key.varinconsistent?
    key.add_translation Translation.new(name: 'de.session.login',
                                        text: 'Log ind %{user}')
    assert_equal true, key.varinconsistent?
  end
end
