# frozen_string_literal: true
require 'test_helper'
require 'translator/category'

class TestCategory < Minitest::Test
  def setup
    @category = Category.new(name: 'test')
    @key = Minitest::Mock.new([0])
  end

  def test_init_name
    assert_equal('test', @category.name)
  end

  def test_init_keys
    assert_empty(@category.keys)
  end

  def test_add_key
    @category.add_key(@key)
    assert_includes(@category.keys, @key)
  end

  def test_is_complete
    @category.add_key(@key)
    @key.expect :complete?, true
    assert @category.complete?
  end

  def test_is_not_complete
    @key.expect :complete?, true
    @category.add_key(@key)

    @key2 = Minitest::Mock.new([1])
    @key2.expect :complete?, false
    @category.add_key(@key2)

    assert !@category.complete?
  end
end
