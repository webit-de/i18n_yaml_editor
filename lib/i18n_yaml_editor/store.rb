# encoding: utf-8

require 'set'
require 'pathname'

require 'i18n_yaml_editor/transformation'
require 'i18n_yaml_editor/category'
require 'i18n_yaml_editor/key'
require 'i18n_yaml_editor/translation'

module I18nYamlEditor
  class DuplicateTranslationError < StandardError; end

  # Store keeps all i18n data
  class Store
    include Transformation

    attr_accessor :categories, :keys, :translations, :locales

    def initialize
      @categories = {}
      @keys = {}
      @translations = {}
      @locales = Set.new
    end

    def add_translation(translation)
      check_duplication! translation

      translations[translation.name] = translation

      locales.add(translation.locale)
      key = init_key(translation)
      init_category(key)
    end

    def init_key(translation)
      key = (keys[translation.key] ||= Key.new(name: translation.key))
      key.add_translation(translation)
      key
    end

    def init_category(key)
      category = (categories[key.category] ||= Category.new(name: key.category))
      category.add_key(key)
    end

    def add_key(key)
      keys[key.name] = key
    end

    def filter_keys(options = {})
      filters = filters(options)
      keys.select { |_, key| filters.all? { |filter| filter.call(key) } }
    end

    def create_missing_keys
      keys.each do|_name, key|
        missing_locales = locales - key.translations.map(&:locale)
        missing_locales.each do|locale|
          translation = key.translations.first
          name = "#{locale}.#{key.name}"
          path = translation_path locale, translation
          add_translation(Translation.new(name: name, file: path))
        end
      end
    end

    def from_yaml(yaml, file = nil)
      translations = flatten_hash(yaml)
      translations.each do|name, text|
        translation = Translation.new(name: name, text: text, file: file)
        add_translation(translation)
      end
    end

    def to_yaml
      result = {}
      files = translations.values.group_by(&:file)
      files.each do|file, translations|
        file_result = {}
        translations.each do|translation|
          file_result[translation.name] = translation.text
        end
        result[file] = nest_hash(file_result)
      end
      result
    end

    private

    def translation_path(locale, translation)
      # this just replaces the locale part of the file name. should
      # be possible to do in a simpler way. gsub, baby.
      path = Pathname.new(translation.file)
      dirs, file = path.split
      file = file.to_s.split('.')
      file[-2] = locale
      file = file.join('.')
      dirs.join(file).to_s
    end

    def filters(options)
      list = []
      list << key_filter(options) if options.key?(:key)
      list << complete_filter(options) if options.key?(:complete)
      list << empty_filter(options) if options.key?(:empty)
      list << text_filter(options) if options.key?(:text)
      list
    end

    def key_filter(options)
      ->(k) { k.name =~ options[:key] }
    end

    def complete_filter(options)
      ->(k) { k.complete? == options[:complete] }
    end

    def text_filter(options)
      ->(k) { k.translations.any? { |t| t.text =~ options[:text] } }
    end

    def empty_filter(options)
      ->(k) { k.empty? == options[:empty] }
    end

    def check_duplication!(translation)
      existing = translations[translation.name]
      return unless existing
      error_message = error_message(translation, existing)
      fail DuplicateTranslationError, error_message
    end

    def error_message(translation, existing)
      "#{translation.name} detected in #{translation.file} and #{existing.file}"
    end
  end
end
