# frozen_string_literal: true

require 'set'

module I18nYamlEditor
  # This is a category
  class Category
    attr_accessor :name, :keys

    def initialize(attributes = {})
      @name = attributes[:name]
      @keys = Set.new
    end

    # Adds a given key to this category's list of keys
    # @param key [Key] key to be added to this category's list of keys
    def add_key(key)
      keys.add(key)
    end

    # Checks and returns if all keys are complete
    # @return [true, false]
    def complete?
      keys.all?(&:complete?)
    end
  end
end
