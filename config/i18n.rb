# frozen_string_literal: true

require 'i18n'

I18n.config.available_locales = :en
I18n.load_path << Dir[File.expand_path('./config/locales') + '/*.yml']
