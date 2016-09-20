# frozen_string_literal: true
require 'guard/compat/plugin'

# Yard is an inline guard that keeps the docs up-to-date and
# checks documentation coverage
::Guard.const_set('Yard',
                  Class.new(::Guard::Plugin) do
                    def start
                      UI.info 'Inspecting Ruby documentation with yard'
                      `yard`
                      puts yard = `yard stats --list-undoc --compact`
                      !yard.match(/Undocumented Objects/).nil?
                    end

                    def run_on_modifications(_paths)
                      UI.info 'Inspecting Ruby documentation with yard'
                      `yard`
                      puts yard = `yard stats --list-undoc --compact`
                      !yard.match(/Undocumented Objects/).nil?
                    end
                  end)

# interactor :off

guard :yard do
  watch(%r{^lib/(.+)\.rb$})
end

guard :rubocop do
  watch(/.+\.rb|Guardfile|Rakefile|.+\.gemspec/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard :minitest do
  watch(%r{^spec/(.*)_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})         { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper\.rb$}) { 'spec' }
end
