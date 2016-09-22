# encoding: utf-8
# frozen_string_literal: true

require 'cuba'
require 'cuba/render'
require 'bigdecimal'

require 'i18n_yaml_editor/app'

module I18nYamlEditor
  # The frontend rendering engine
  class Web < Cuba
    plugin Cuba::Render

    settings[:render][:template_engine] = 'erb'
    settings[:render][:views] = File.expand_path(
      File.join(File.dirname(__FILE__), '..', '..', 'views')
    )

    use Rack::ShowExceptions

    # Reads global App instance
    def app
      I18nYamlEditor.app
    end

    define do
      on get, root do
        on param('filters') do |filters|
          opts = {}
          opts[:key] = /#{filters["key"]}/ unless filters['key'].to_s.empty?
          opts[:text] = /#{filters["text"]}/i unless filters['text'].to_s.empty?
          opts[:complete] = false if filters['incomplete'] == 'on'
          opts[:empty] = true if filters['empty'] == 'on'

          keys = app.store.filter_keys(opts)

          res.write view('translations.html', keys: keys, filters: filters)
        end

        on default do
          categories = app.store.categories.sort
          res.write view('categories.html', categories: categories, filters: {})
        end
      end

      on post, 'update' do
        translations = req['translations']
        app.save_translations(translations) if translations

        url = Rack::Utils.build_nested_query(filters: req['filters'])
        res.redirect "/?#{url}"
      end

      on get, 'debug' do
        res.write partial('debug.html',
                          translations: app.store.translations.values)
      end
    end
  end
end
