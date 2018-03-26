# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |s|
  s.name     = 'translator'
  s.version  = '1.3.1'
  s.date     = '2015-10-07'
  s.summary  = 'Translator'
  s.email    = 'wolfgang.teuber@sage.com'
  s.homepage = 'http://github.com/Sage/translator'
  s.description = 'Translator'
  s.authors = ['Harry Vangberg', 'Wolfgang Teuber']
  s.executables << 'translator'
  s.files = [
    'README.md',
    'Rakefile',
    'translator.gemspec',
    'bin/translator',
    'lib/translator.rb',
    'lib/translator/app.rb',
    'lib/translator/category.rb',
    'lib/translator/core_ext.rb',
    'lib/translator/key.rb',
    'lib/translator/store.rb',
    'lib/translator/filter.rb',
    'lib/translator/update.rb',
    'lib/translator/cast.rb',
    'lib/translator/transformation.rb',
    'lib/translator/translation.rb',
    'lib/translator/web.rb',
    'views/categories.html.erb',
    'views/debug.html.erb',
    'views/layout.erb',
    'views/translations.html.erb'
  ]
  s.test_files = [
    'test/test_helper.rb',
    'test/unit/test_app.rb',
    'test/unit/test_category.rb',
    'test/unit/test_key.rb',
    'test/unit/test_store.rb',
    'test/unit/test_transformation.rb',
    'test/unit/test_translation.rb'
  ]
  s.add_dependency 'activesupport', '>= 4.0.2'
  s.add_dependency 'cuba', '>= 3'
  s.add_dependency 'psych', '>= 1.3.4'
  s.add_dependency 'tilt', '>= 1.3'

  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'cane'
  s.add_development_dependency 'flay'
  s.add_development_dependency 'flog'
  s.add_development_dependency 'github-markup'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency 'inch'
  s.add_development_dependency 'minitest-line'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'pry-doc'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'yard'
end
# rubocop:enable Metrics/BlockLength
