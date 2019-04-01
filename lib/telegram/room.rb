# frozen_string_literal: true

require 'telegram/bot'

module Telegram
  class Room
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: (3..6).map(&:to_s),
      one_time_keyboard: true
    )

    def initialize(bot, chat_id)
      @api = bot.api
      @chat_id = chat_id
    end

    def print(variants: [], **attributes)
      attributes[:reply_markup] = keyboard(variants) unless variants.empty?
      @api.send_message(chat_id: @chat_id, **attributes)
    end

    private

    def keyboard(variants)
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: variants.map(&:to_s),
        one_time_keyboard: true
      )
    end
  end
end
