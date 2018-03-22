# frozen_string_literal: true

module Translator
  # A Translation holds information about its name, file and text
  class Translation
    attr_accessor :name, :file, :text

    def initialize(attributes = {})
      @name, @file, @text = attributes.values_at(:name, :file, :text)
    end

    # This translation's key
    def key
      @key ||= name.split('.')[1..-1].join('.')
    end

    # This translation's locale
    def locale
      @locale ||= name.split('.').first
    end
  end
end
