require 'test_helper'
require 'i18n_yaml_editor/transformation'

class TestTransformation < Minitest::Test
  I18N_HASH = {
    'da.session.login' => 'Log ind',
    'da.session.logout' => 'Log ud',
    'en.session.login' => 'Log in',
    'en.session.logout' => 'Log out'
  }.freeze

  def test_flatten_hash
    input = {
      da: {
        session: { login: 'Log ind', logout: 'Log ud' }
      },
      en: {
        session: { login: 'Log in', logout: 'Log out' }
      }
    }

    assert_equal I18N_HASH, Transformation.flatten_hash(input)
  end

  def test_nest_hash
    expected = {
      da: {
        session: { login: 'Log ind', logout: 'Log ud' }
      },
      en: {
        session: { login: 'Log in', logout: 'Log out' }
      }
    }.with_indifferent_access

    assert_equal expected, Transformation.nest_hash(I18N_HASH)
  end

  def test_nest_hash_transformation_error
    assert_raises(TransformationError) do
      Transformation.nest_hash(error: 'value')
    end
  end
end
