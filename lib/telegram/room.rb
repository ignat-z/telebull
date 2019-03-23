# frozen_string_literal: true

require 'telegram/bot'

module Telegram
  class Room
    def initialize(bot, chat_id)
      @api = bot.api
      @chat_id = chat_id
    end

    def print(attributes)
      @api.send_message(chat_id: @chat_id, **attributes)
    end
  end
end
