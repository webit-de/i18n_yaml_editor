# frozen_string_literal: true
require 'set'

module I18nYamlEditor
  # This is a key
  class Key
    attr_accessor :name, :translations

    def initialize(attributes = {})
      @name = attributes[:name]
      @translations = Set.new
    end

    def add_translation(translation)
      translations.add(translation)
    end

    def category
      @category ||= name.split('.').first
    end

    def complete?
      translations.all? { |t| t.text.to_s !~ /\A\s*\z/ } || empty?
    end

    def empty?
      translations.all? { |t| t.text.to_s =~ /\A\s*\z/ }
    end
  end
end
