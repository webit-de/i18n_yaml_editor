# frozen_string_literal: true

require 'test_helper'
require 'i18n_yaml_editor/core_ext'

class TestHash < Minitest::Test
  def setup
    @obj = { b: { z: 20, x: 10 }, a: nil }
  end

  def test_method_exists
    assert_respond_to({}, :sort_by_key)
  end

  def test_sort_by_key_depth
    # Sorts keys in level 1 only
    assert @obj.sort_by_key, a: nil, c: { z: 20, x: 10 }

    # Does not modify the original object
    assert @obj, b: { z: 20, x: 10 }, a: nil
  end

  def test_sort_by_key_depth_recursive
    # Sorts keys in all levels
    assert @obj.sort_by_key(true), a: nil, c: { x: 10, z: 20 }

    # Does not modify the original object
    assert @obj, b: { z: 20, x: 10 }, a: nil
  end
end
