# frozen_string_literal: true

require './lib/bulls_cows/game'
require './lib/telegram/default_chat'
require './lib/telegram/game_workflow'
require './lib/telegram/game_fiber'
require './lib/telegram/room'

module Telegram
  class Runtime
    def initialize(bot)
      @bot = bot
      @dialogs = Hash.new do |hash, chat_id|
        hash[chat_id] = DefaultChat.new(Room.new(@bot, chat_id))
      end
    end

    def loop(message)
      @dialogs[message.chat.id] = decide(message).call(message)
      self
    end

    private

    def decide(message)
      case message.text
      when '/startw' then GameWorkflow.new(room(message))
      when '/startx' then GameFiber.new(room(message))
      when '/cancel' then DefaultChat.new(room(message))
      else @dialogs[message.chat.id]
      end
    end

    def room(message)
      Room.new(@bot, message.chat.id)
    end
  end
end
