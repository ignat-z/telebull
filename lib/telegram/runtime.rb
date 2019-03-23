# frozen_string_literal: true

require './lib/bulls_cows/game'
require './lib/telegram/dialog_actor'
require './lib/telegram/game_workflow'
require './lib/telegram/room'

module Telegram
  class Runtime
    def initialize(bot)
      @bot = bot
      @dialogs = Hash.new do |hash, chat_id|
        hash[chat_id] = GameWorkflow.new(Room.new(@bot, chat_id))
      end
    end

    def loop(message)
      @dialogs[message.chat.id].transfer!(message)
      self
    end
  end
end
