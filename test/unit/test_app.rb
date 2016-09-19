# frozen_string_literal: true
require 'test_helper'
require 'i18n_yaml_editor/app'

class TestApp < Minitest::Test
  def test_save_translations
    Dir.mktmpdir do |dir|
      FileUtils.copy './example/session.en.yml', dir
      @app = App.new(dir)
      @app.load_translations
      @app.save_translations('en.session.create.logged_in' => 'Test123')
      assert_match(/logged_in: Test123\n/, File.read(dir + '/session.en.yml'))
    end
  end

  def test_save_translations_empty
    Dir.mktmpdir do |dir|
      FileUtils.copy './example/session.en.yml', dir
      @app = App.new(dir)
      @app.load_translations
      _stdout, stderr = capture_io do
        @app.save_translations('does.not.exist' => 'foo')
      end
      assert_match('Translation not found', stderr)
    end
  end

  def test_save_translations_array
    Dir.mktmpdir do |dir|
      FileUtils.copy './example/da.yml', dir
      @app = App.new(dir)
      @app.load_translations
      @app.save_translations('da.day_names' => "Test1\r\nTest2")
      assert_match(/- Test2\n/, File.read(dir + '/da.yml'))
    end
  end

  def test_save_translations_boolean
    Dir.mktmpdir do |dir|
      FileUtils.copy './example/session.en.yml', dir
      @app = App.new(dir)
      @app.load_translations
      @app.save_translations('en.numbers.use_local_format' => 'false')
      assert_match(/use_local_format: false\n/,
                   File.read(dir + '/session.en.yml'))
    end
  end

  def test_save_translations_number
    Dir.mktmpdir do |dir|
      FileUtils.copy './example/session.en.yml', dir
      @app = App.new(dir)
      @app.load_translations
      @app.save_translations('en.numbers.precision' => '10')
      assert_match(/precision: 10\n/, File.read(dir + '/session.en.yml'))
    end
  end
end
