# frozen_string_literal: true
require 'test_helper'
require 'i18n_yaml_editor/app'

class TestApp < Minitest::Test
  def test_load_translations_error
    Dir.mktmpdir do |dir|
      file = dir + '/does_not_exist.yml'
      @app = App.new(file)
      _stdout, stderr = capture_io do
        @app.load_translations
      end
      assert_match('No valid translation file given', stderr)
    end
  end

  def test_load_translations_dir
    store_from_yaml = lambda do |yaml, file|
      assert_equal(yaml['en']['session']['create']['logged_in'], 'Welcome!')
      assert_match(%r{/session\.en\.yml\z}, file)
    end

    Dir.mktmpdir do |dir|
      FileUtils.copy './example/session.en.yml', dir
      @app = App.new(dir)
      @app.store.stub(:from_yaml, store_from_yaml) { @app.load_translations }
    end
  end

  def test_load_translations_file_list
    Dir.mktmpdir do |dir|
      FileUtils.copy './example/session.en.yml', dir
      list_path = File.join(dir, 'file_list')
      File.open(list_path, 'w') { |f| f.write(Dir[dir + '/*.yml'] * "\n") }
      @app = App.new(list_path)
      @app.load_translations
    end
    assert @app.store.translations.key?('en.session.create.logged_in')
  end

  def test_load_translations_translation_file
    store_from_yaml = lambda do |yaml, file|
      assert_equal(yaml['en']['session']['create']['logged_in'], 'Welcome!')
      assert_match(%r{/session\.en\.yml\z}, file)
    end

    Dir.mktmpdir do |dir|
      FileUtils.copy './example/session.en.yml', dir
      @app = App.new(dir + '/session.en.yml')
      @app.store.stub(:from_yaml, store_from_yaml) { @app.load_translations }
    end
  end
end
