# frozen_string_literal: true

require 'set'
require 'pathname'

require 'translator/transformation'
require 'translator/filter'
require 'translator/update'
require 'translator/category'
require 'translator/key'
require 'translator/translation'

module Translator
  # Raised when translation entries have the same key
  class DuplicateTranslationError < StandardError; end

  # Store keeps all i18n data
  class Store
    include Transformation
    include Filter
    include Update

    attr_accessor :categories, :keys, :translations, :locales

    def initialize
      @categories = {}
      @keys = {}
      @translations = {}
      @locales = Set.new
    end

    # Adds a given translation to the store
    def add_translation(translation)
      check_duplication! translation

      translations[translation.name] = translation

      locales.add(translation.locale)
      key = init_key(translation)
      init_category(key)
    end

    # Generates a new key with the given translation
    def init_key(translation)
      key = (keys[translation.key] ||= Key.new(name: translation.key))
      key.add_translation(translation)
      key
    end

    # Generates a new category with the given key
    def init_category(key)
      category = (categories[key.category] ||= Category.new(name: key.category))
      category.add_key(key)
    end

    # Adds a key to this store
    def add_key(key)
      keys[key.name] = key
    end

    # Creates all keys for each locale that doesn't have all keys from all
    # other locales
    def create_missing_keys
      keys.each do |_name, key|
        missing_locales = locales - key.translations.map(&:locale)
        missing_locales.each do |locale|
          translation = key.translations.first
          name = "#{locale}.#{key.name}"
          path = translation_path locale, translation
          add_translation(Translation.new(name: name, file: path))
        end
      end
    end

    # Adds a translation for every entry in a given yaml hash
    def from_yaml(yaml, file = nil)
      translations = flatten_hash(yaml)
      translations.each do |name, text|
        translation = Translation.new(name: name, text: text, file: file)
        add_translation(translation)
      end
    end

    # Returns a hash with the structure of a i18n
    def to_yaml
      result = {}
      files = translations.values.group_by(&:file)
      files.each do |file, translations|
        file_result = {}
        translations.each do |translation|
          file_result[translation.name] = translation.text
        end
        result[file] = nest_hash(file_result)
      end
      result
    end

    private

    def translation_path(locale, translation)
      translation.file.gsub(/(.*)[A-z]{2}(\.yml)\z/, "\\1#{locale}\\2")
    end

    def check_duplication!(translation)
      existing = translations[translation.name]
      return unless existing
      error_message = error_message(translation, existing)
      raise DuplicateTranslationError, error_message
    end

    def error_message(translation, existing)
      "#{translation.name} detected in #{translation.file} and #{existing.file}"
    end
  end
end
