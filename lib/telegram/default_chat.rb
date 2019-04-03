# frozen_string_literal: true

require 'telegram/bot'

module Telegram
  class DefaultChat
    HELP = <<~MESSAGE
      /startw - start Bulls'n'Cows Workflow-based version
      /startx - start Bulls'n'Cows Fiber-based version
      /cancel - interupt current seession
    MESSAGE

    def initialize(room)
      @room = room
    end

    def call(_message)
      @room.print(text: HELP)
      self
    end
  end
end
