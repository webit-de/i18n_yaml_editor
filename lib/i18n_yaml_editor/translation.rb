# encoding: utf-8

module I18nYamlEditor
  class Translation
    attr_accessor :name, :file, :text

    def initialize(attributes = {})
      @name, @file, @text = attributes.values_at(:name, :file, :text)
    end

    def key
      @key ||= name.split('.')[1..-1].join('.')
    end

    def locale
      @locale ||= name.split('.').first
    end
  end
end
