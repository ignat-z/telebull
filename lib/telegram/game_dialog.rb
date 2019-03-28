# frozen_string_literal: true

module Telegram
  class GameDialog
    MINIMAL_DIGITS = 3
    KEYBOARD = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: (3..6).map(&:to_s),
      one_time_keyboard: true
    )

    def call
      Fiber.new do |message|
        reply("Hello, #{message.from.first_name}!")
        game = BullsCows::Game.new(digits: request_digits)
        attempt = request('Got it, your guess?')
        attempt = wait until process_attempt(game, attempt).completed
        answer("You're right!")
      end
    end

    private

    def request_digits
      loop do
        answer = request('How many digits do you want? (N > 2)',
                         reply_markup: KEYBOARD).text.to_i
        break(answer) if answer >= MINIMAL_DIGITS
      end
    end

    def process_attempt(game, attempt)
      game.guess(attempt.text).tap do |result|
        reply("Guess ##{result.counter}: #{result.bulls}🐂, #{result.cows}🐄")
      end
    end

    # --------------------------------------------------------------------------

    def wait
      Fiber.yield(:wait, {})
    end

    def request(question, **markup)
      Fiber.yield(:question, text: question, **markup)
    end

    def reply(statement)
      Fiber.yield(:statement, text: statement)
    end

    def answer(text)
      Fiber.yield(:end, text: text)
    end
  end
end
