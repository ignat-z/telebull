# frozen_string_literal: true

require 'fiber'
require 'telegram/bot'

require './lib/telegram/game_dialog.rb'

module Telegram
  class GameFiber
    START_DIALOG = -> { Telegram::GameDialog.new.call }

    def initialize(room, dialog: START_DIALOG)
      @room = room
      @dialog = dialog.call
    end

    def call(message)
      result = @dialog.resume(message)
      @room.print(**result.last) unless result.first == :wait
      decide(result, message)
      self
    end

    def decide(result, message)
      case result.first
      when :question then @dialog
      when :wait then @dialog
      when :statement then call(message)
      when :end then reborn
      end
    end

    def reborn
      @dialog.resume # have to die to reborn
      @dialog = START_DIALOG.call
    end
  end
end
