# frozen_string_literal: true

# Translator
module Translator
  class << self
    attr_accessor :app
  end
end

require 'translator/app'
require 'translator/category'
require 'translator/key'
require 'translator/store'
require 'translator/transformation'
require 'translator/translation'
require 'translator/web'
