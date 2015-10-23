# encoding: utf-8

require 'set'
require 'pathname'

require 'i18n_yaml_editor/transformation'
require 'i18n_yaml_editor/category'
require 'i18n_yaml_editor/key'
require 'i18n_yaml_editor/translation'

module I18nYamlEditor
  class DuplicateTranslationError < StandardError; end

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
      if existing = translations[translation.name]
        message = "#{translation.name} detected in #{translation.file} and #{existing.file}"
        fail DuplicateTranslationError.new(message)
      end

      translations[translation.name] = translation

      add_locale(translation.locale)

      key = (keys[translation.key] ||= Key.new(name: translation.key))
      key.add_translation(translation)

      category = (categories[key.category] ||= Category.new(name: key.category))
      category.add_key(key)
    end

    def add_key(key)
      keys[key.name] = key
    end

    def add_locale(locale)
      locales.add(locale)
    end

    def filter_keys(options = {})
      filters = []
      filters << ->(k) { k.name =~ options[:key] } if options.key?(:key)
      if options.key?(:complete)
        filters << ->(k) { k.complete? == options[:complete] }
      end
      filters << ->(k) { k.empty? == options[:empty] } if options.key?(:empty)
      if options.key?(:text)
        filters << lambda do|k|
          k.translations.any? { |t| t.text =~ options[:text] }
        end
      end

      keys.select do|_name, key|
        filters.all? { |filter| filter.call(key) }
      end
    end

    def create_missing_keys
      keys.each do|_name, key|
        missing_locales = locales - key.translations.map(&:locale)
        missing_locales.each do|locale|
          translation = key.translations.first

          # this just replaces the locale part of the file name. should
          # be possible to do in a simpler way. gsub, baby.
          path = Pathname.new(translation.file)
          dirs, file = path.split
          file = file.to_s.split('.')
          file[-2] = locale
          file = file.join('.')
          path = dirs.join(file).to_s

          new_translation = Translation.new(name: "#{locale}.#{key.name}", file: path)
          add_translation(new_translation)
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
  end
end
