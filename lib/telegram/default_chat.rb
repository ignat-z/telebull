# frozen_string_literal: true

require 'telegram/bot'

module Telegram
  class DefaultChat
    HELP = <<~MESSAGE
      /startw -- to start Bulls'n'Cows Workflow-based version
      /startx -- to start Bulls'n'Cows Fiber-based version
      any     -- run this dialog
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
