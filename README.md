# Translator [![Build Status](https://travis-ci.org/Sage/translator.svg?branch=master)](https://travis-ci.org/Sage/translator) [![Maintainability](https://api.codeclimate.com/v1/badges/f71fb2039dd7d50eb90d/maintainability)](https://codeclimate.com/github/Sage/translator/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/f71fb2039dd7d50eb90d/test_coverage)](https://codeclimate.com/github/Sage/translator/test_coverage) [![Documentation Status](http://inch-ci.org/github/Sage/translator.svg?branch=master)](http://inch-ci.org/github/Sage/translator) [![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Sage/translator/blob/master/LICENSE) [![Dependency Status](https://gemnasium.com/badges/github.com/Sage/translator.svg)](https://gemnasium.com/github.com/Sage/translator)

Translator is based on [IYE](https://github.com/firmafon/iye).
Translator makes it easy to translate your Rails I18N files and keep them up to date.
It uses YAML files directly, so you don't need to keep a separate database in sync.
This has several benefits:

* Branching and diffing is trivial
* It does not alter the workflow for developers etc., whom can continue editing the
  YAML files directly
* If your YAML files are organized in subfolders, this structure is kept intact

![Translator](https://cloud.githubusercontent.com/assets/1446195/10295880/1f829dd6-6bc4-11e5-9a08-bb79d9864bdb.png)

## Prerequisites

You need to understand a few things about Translator for it to make sense, mainly:

* Translator does not create new keys - keys must exist for at least one locale in the YAML files
* Translator does not create new locales - at least one key must exist for each locale in the YAML files

## Workflow

1. Install Translator:

        $ git clone git@github.com:Sage/translator.git
        $ cd translator
        $ gem build translator.gemspec
        $ gem install translator-1.3.1.gem

2. The `translator` executable is now available, use it wherever you want.

        $ translator path/to/i18n/locales [port]

    At this point Translator loads all translation keys for all locales, and creates any
    keys that might be missing for existing locales, the default port is 5050

3. Point browser at [http://localhost:5050](http://localhost:5050)
4. Make changes and press 'Save' - each time you do this, all the keys will be
   written to their original YAML files.
5. Review your changes before committing files, e.g. by using `git diff`.

## Development

### Getting started
        $ git clone git@github.com:Sage/translator.git
        $ cd translator
        $ gem install bundler
        $ bundle install
        $ SIMPLE_COV=true bundle exec guard


## License

This gem is available as open source under the terms of the
[MIT licence](LICENSE).

Copyright (c) 2018 Sage Group Plc. All rights reserved.
