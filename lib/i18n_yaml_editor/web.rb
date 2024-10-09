# frozen_string_literal: true

require 'cuba'
require 'cuba/render'
require 'bigdecimal'

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
          opts[:varinconsistent] = true if filters['varinconsistent'] == 'on'
          languages = {}
          app.store.locales.each do |key|
            languages[key] = filters[key] == 'on'
          end
          # if no language filter is used all languages are shown
          if languages.values.none?
            languages.each_key do |language|
              languages[language] = true
            end
          end

          keys = app.store.filter_keys(opts)

          res.write view('translations.html', keys: keys, filters: filters, languages: languages)
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
