# frozen_string_literal: true

$LOAD_PATH.unshift('lib')

require 'translator/app'
require 'translator/web'

app = Translator::App.new('example')
app.load_translations
app.store.create_missing_keys

run Translator::Web
