# frozen_string_literal: true

require 'test_helper'
require 'i18n_yaml_editor/web'

# TODO: imprive tests in TestWeb
class TestWeb < Minitest::Test
  include Rack::Test::Methods

  def setup
    app = nil
    capture_io { app = App.new('examples') }

    app.load_translations
    app.store.create_missing_keys
    I18nYamlEditor.app = app
  end

  def app
    Rack::Builder.new Web
  end

  def test_get_root
    capture_io { get '/' }

    refute_nil last_response
  end

  def test_get_root_filter
    capture_io { get '/', filters: { key: '^app_name' } }

    refute_nil last_response
  end

  def test_get_debug
    capture_io { get '/debug' }

    refute_nil last_response
  end

  def test_get_update
    capture_io do
      post '/update', 'filters' => { 'key' => '^day_names' },
                      'translations' => {
                        'da.day_names' => "søndag\r\nmandag\r\nonsdag\r\n"\
                                          "torsdag\r\nfredag\r\nlørdag",
                        'en.day_names' => 'lol'
                      }
    end
    refute_nil last_response
  end
end
