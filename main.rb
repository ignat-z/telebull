#!/usr/bin/env ruby
# frozen_string_literal: true

require 'dotenv/load'
require 'telegram/bot'

require './config/i18n'
require './lib/telegram/runtime'

Telegram::Bot::Client.run(
  ENV.fetch('TELEGRAM_BOT_API_TOKEN'),
  logger: Logger.new($stdout)
) do |bot|
  bot.listen(&Telegram::Runtime.new(bot).method(:loop))
end
