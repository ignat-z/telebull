# frozen_string_literal: true

require 'telegram/bot'

require './lib/telegram/dialog_actor'

module Telegram
  class GameWorkflow
    extend Forwardable

    NEW_GAME           = 0
    WAITING_FOR_DIGITS = 1
    WAITING_FOR_GUESS  = 2
    END_GAME           = 3

    Transition = Struct.new(:from, :to, :action)

    TRANSITIONS = [
      Transition.new(NEW_GAME, WAITING_FOR_DIGITS, :start_game),
      Transition.new(WAITING_FOR_DIGITS, WAITING_FOR_GUESS, :store_number),
      Transition.new(WAITING_FOR_GUESS, NEW_GAME, :complete)
    ].freeze

    TRIGGER_MESSAGE = '/start'
    KEYBOARD = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: (3..6).map(&:to_s),
      one_time_keyboard: true
    )
    MINIMAL_DIGITS = 3

    def initialize(room, game_state: NEW_GAME,
                   dialog_state: DialogActor::NEW_CHAT)
      @room = room
      @game_state = game_state
      @dialog = DialogActor.new(state: dialog_state)
    end

    def_delegators :@dialog, *DialogActor::TRANSITIONS.keys

    def call(message)
      reply
      transition = TRANSITIONS.find { |possible| possible.from == @game_state }
      @game_state = transition.to if method(transition.action).call(message)
      self
    end

    def start_game(message)
      say do
        @room.print(text: I18n.t('game.hello', name: message.from.first_name))
      end
      ask { @room.print(text: I18n.t('game.request'), reply_markup: KEYBOARD) }
      true
    end

    def store_number(message)
      return false if message.text.to_i < MINIMAL_DIGITS

      @game = BullsCows::Game.new(digits: message.text.to_i)
      ask { @room.print(text: I18n.t('game.guess')) }
      true
    end

    def complete(message)
      @game.guess(message.text).tap do |result|
        say do
          @room.print(text:
            I18n.t('game.result', result.to_h.slice(:counter, :bulls, :cows)))
        end
        result.completed ? suicide(message) : ask
      end.completed
    end

    def suicide(_message)
      finish { @room.print(text: I18n.t('game.final')) }
      @game_state = NEW_GAME
      @dialog = DialogActor.new(state: DialogActor::NEW_CHAT)
    end
  end
end
