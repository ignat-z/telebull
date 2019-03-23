#!/usr/bin/env ruby
# frozen_string_literal: true

require 'dotenv/load'
require 'telegram/bot'

require './lib/telegram/runtime'

Telegram::Bot::Client.run(ENV.fetch('TELEGRAM_BOT_API_TOKEN')) do |bot|
  bot.listen(&Telegram::Runtime.new(bot).method(:loop))
end
