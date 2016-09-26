# frozen_string_literal: true
require 'test_helper'
require 'translator/app'

class TestApp < Minitest::Test
  def test_new_no_path_given
    assert_raises(ArgumentError) { App.new }
  end

  def test_new_given_path
    app = App.new('my_path')
    assert_match(/my_path\z/, app.instance_variable_get(:@path))
  end

  def test_new_default_port
    app = App.new('')
    assert_equal 5050, app.instance_variable_get(:@port)
  end

  def test_new_given_port
    app = App.new('', 3333)
    assert_equal 3333, app.instance_variable_get(:@port)
  end

  def test_new_store
    app = App.new('')
    refute_nil app.instance_variable_get(:@store)
  end

  def test_new_store_accessor
    app = App.new('')
    assert_equal app.store, app.instance_variable_get(:@store)
  end

  def test_new_exposure
    app = App.new('')
    assert_equal(Translator.app, app)
  end
end
