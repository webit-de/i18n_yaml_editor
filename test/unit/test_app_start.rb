# frozen_string_literal: true
require 'test_helper'
require 'i18n_yaml_editor/app'

class TestApp < Minitest::Test
  def setup
    @app = App.new('.')
    @fake_load_translations = -> { raise 'called load_translations' }
    @fake_store_create_missing_keys = -> { raise 'called create_missing_keys' }
    @fake_rack_server_start = lambda do |options|
      assert_equal({ app: I18nYamlEditor::Web, Port: 5050 }, options)
      raise 'called rack_server_start'
    end
  end

  def test_start_file_not_found
    Dir.mktmpdir do |dir|
      file = dir + '/does_not_exist.yml'
      @app.stub :load_translations, @fake_load_translations do
        @app = App.new(file)
        assert_raises("File #{@path} not found.") do
          @app.start
        end
      end
    end
  end

  def test_start_load_translations
    stdout, _stderr = capture_io do
      @app.stub :load_translations, @fake_load_translations do
        assert_raises('called load_translations') { @app.start }
      end
    end
    assert_match(/ \* Loading translations from/, stdout)
  end

  def test_store_create_missing_keys
    stdout, _stderr = capture_io do
      @app.stub :load_translations, nil do
        @app.store.stub :create_missing_keys, @fake_store_create_missing_keys do
          assert_raises('called create_missing_keys') { @app.start }
        end
      end
    end
    assert_match(/ \* Creating missing translations/, stdout)
  end

  def test_server_start
    stdout, _stderr = capture_io do
      @app.stub :load_translations, nil do
        @app.store.stub :create_missing_keys, nil do
          Rack::Server.stub :start, @fake_rack_server_start do
            assert_raises('called rack_server_start') { @app.start }
          end
        end
      end
    end
    assert_match(/ \* Starting web editor at port /, stdout)
  end
end
