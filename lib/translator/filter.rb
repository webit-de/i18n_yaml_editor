# frozen_string_literal: true

module Translator
  # Transformation provides
  module Filter
    # Selects keys from this store according to the given filter options
    def filter_keys(options = {})
      filters = filters(options)
      keys.select { |_, key| filters.all? { |filter| filter.call(key) } }
    end

    private

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

    def empty_filter(options)
      ->(k) { k.empty? == options[:empty] }
    end

    def text_filter(options)
      ->(k) { k.translations.any? { |t| t.text =~ options[:text] } }
    end
  end
end
