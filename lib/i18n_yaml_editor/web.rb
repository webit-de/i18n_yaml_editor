# encoding: utf-8

require 'cuba'
require 'cuba/render'
require 'bigdecimal'

require 'i18n_yaml_editor/app'

module I18nYamlEditor
  # my doc
  class Web < Cuba
    plugin Cuba::Render

    settings[:render][:template_engine] = 'erb'
    settings[:render][:views] = File.expand_path(
      File.join(File.dirname(__FILE__), '..', '..', 'views'))

    use Rack::ShowExceptions

    def app
      I18nYamlEditor.app
    end

    def cast(klass, value)
      return '' if value.blank?

      if klass < Numeric
        num = BigDecimal.new(value)
        num.frac == 0 ? num.to_i : num.to_f
      elsif [TrueClass, FalseClass].include?(klass)
        value.casecmp('true').zero?
      elsif klass == Array
        value.split("\r\n")
      end
    end

    define do
      on get, root do
        on param('filters') do |filters|
          opts = {}
          opts[:key] = /#{filters["key"]}/ if filters['key'].to_s.size > 0
          opts[:text] = /#{filters["text"]}/i if filters['text'].to_s.size > 0
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
        if translations
          store = app.store.translations.values.group_by(&:key)

          translations.each do |name, text|
            objs = store[app.store.translations[name].key].map(&:text)
            obj = objs.find { |t| t.present? || t == false }
            data_type = obj.class
            data_type = String if data_type == NilClass
            if data_type == Array
              klasses = obj.map(&:class).uniq!
              if klasses.length < 2
                app.store.translations[name].text = []
                cast(data_type, text).each do |item|
                  app.store.translations[name].text << cast(klasses[0], item)
                end
              end
            else
              app.store.translations[name].text = cast(data_type, text)
            end
          end

          app.save_translations(translations)
        end

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
