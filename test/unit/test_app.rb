require 'test_helper'
require 'i18n_yaml_editor/app'

class TestApp < Minitest::Test
  def test_default_port
    app = App.new('')
    assert_equal 5050, app.instance_variable_get(:@port)
  end

  def test_given_port
    app = App.new('', 3333)
    assert_equal 3333, app.instance_variable_get(:@port)
  end
end
