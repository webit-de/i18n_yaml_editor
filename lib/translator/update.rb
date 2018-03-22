# frozen_string_literal: true

require 'translator/cast'

module Translator
  # Provides update functioinality for Store
  module Update
    include Cast

    # Update translations in store
    def update(new_translations)
      translations_in_store = translations.values.group_by(&:key)

      new_translations.each do |name, text|
        if translations[name]
          update_translation(name, text, translations_in_store)
        else
          # rubocop:disable Style/StderrPuts
          $stderr.puts 'Translation not found'
          # rubocop:enable Style/StderrPuts
          next
        end
      end
    end

    private

    def update_array(obj, name, text)
      klasses = obj.map(&:class).uniq!
      return unless klasses.length < 2
      translations[name].text = []
      cast(Array, text).each do |item|
        translations[name].text << cast(klasses[0], item)
      end
    end

    def update_with_type(obj, name, text)
      data_type = obj.class
      data_type = String if data_type == NilClass
      if data_type == Array
        update_array(obj, name, text)
      else
        translations[name].text = cast(data_type, text)
      end
    end

    def update_translation(name, text, translations_in_store)
      objs = translations_in_store[translations[name].key].map(&:text)
      obj = objs.find { |t| t.present? || t == false }
      update_with_type(obj, name, text)
    end
  end
end
