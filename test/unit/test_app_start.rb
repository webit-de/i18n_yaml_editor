# frozen_string_literal: true

require 'test_helper'
require 'translator/app'

class TestApp < Minitest::Test
  def setup
    @app = App.new('.')
    @fake_load_translations = -> { raise 'called load_translations' }
    @fake_store_create_missing_keys = -> { raise 'called create_missing_keys' }
    @fake_rack_server_start = lambda do |options|
      assert_equal({ app: Translator::Web, Port: 5050 }, options)
      raise 'called rack_server_start'
    end
  end

  def test_start_file_not_found
    Dir.mktmpdir do |dir|
      file = dir + '/does_not_exist.yml'
      @app.stub :load_translations, @fake_load_translations do
        @app = App.new(file)
        assert_raises("File #{file} not found.") do
          @app.start
        end
      end
    end
  end

  def test_start_load_translations
    assert_output(/ \* Loading translations from/, '') do
      @app.stub :load_translations, @fake_load_translations do
        assert_raises('called load_translations') { @app.start }
      end
    end
  end

  def test_store_create_missing_keys
    assert_output(/ \* Creating missing translations/, '') do
      @app.stub :load_translations, nil do
        @app.store.stub :create_missing_keys, @fake_store_create_missing_keys do
          assert_raises('called create_missing_keys') { @app.start }
        end
      end
    end
  end

  def test_server_start
    assert_output(/ \* Starting Translator at port /, '') do
      @app.stub :load_translations, nil do
        @app.store.stub :create_missing_keys, nil do
          Rack::Server.stub :start, @fake_rack_server_start do
            assert_raises('called rack_server_start') { @app.start }
          end
        end
      end
    end
  end
end
