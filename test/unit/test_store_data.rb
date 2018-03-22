# frozen_string_literal: true

require 'test_helper'
require 'translator/store'

module TestStoreData
  def self.included(_base)
    include Translator
  end

  def init_test_store_1
    store = Store.new
    store.add_translation tmp_translation_1
    store.locales.add('en')
    store
  end

  def init_test_store_0
    store = Store.new
    store.add_translation tmp_translation_0
    store.locales.add('en')
    store
  end

  def tmp_translation_1
    Translation.new(
      name: 'da.app_name',
      text: 'Oversætter',
      file: '/tmp/da.yml'
    )
  end

  def tmp_translation_0
    Translation.new(
      name: 'da.session.login',
      text: 'Log ind',
      file: '/tmp/session.da.yml'
    )
  end
end
