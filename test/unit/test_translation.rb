# frozen_string_literal: true

require 'test_helper'
require 'translator/translation'

class TestTranslation < Minitest::Test
  def test_key
    translation = Translation.new(name: 'da.session.login')
    assert_equal 'session.login', translation.key
  end

  def test_locale
    translation = Translation.new(name: 'da.session.login')
    assert_equal 'da', translation.locale
  end
end
