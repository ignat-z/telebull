# frozen_string_literal: true

require 'telegram/bot'

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
      Transition.new(WAITING_FOR_GUESS, END_GAME, :complete)
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

    def transfer!(message)
      reply
      transition = TRANSITIONS.find { |possible| possible.from == @game_state }
      @game_state = transition.to if method(transition.action).call(message)
    end

    def start_game(message)
      return false unless message.text == TRIGGER_MESSAGE

      say { @room.print(text: "Hello, #{message.from.first_name}!") }
      ask do
        @room.print(text: 'How many digits do you want? (N > 2)',
                    reply_markup: KEYBOARD)
      end
      true
    end

    def store_number(message)
      if message.text.to_i < MINIMAL_DIGITS
        ask { @room.print(text: 'Invalid number, please, try another') }
        return false
      end
      @game = BullsCows::Game.new(digits: message.text.to_i)
      ask { @room.print(text: 'Got it, your guess?') }
      true
    end

    def complete(message)
      @game.guess(message.text.to_i).tap do |result|
        say do
          @room.print(text:
            "Guess ##{result.counter}: #{result.bulls}🐂, #{result.cows}🐄")
        end

        result.completed ? finish { @room.print(text: "You're right!") } : ask
      end.completed
    end
  end
end
