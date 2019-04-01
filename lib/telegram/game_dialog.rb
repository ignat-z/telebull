# frozen_string_literal: true

module Telegram
  class GameDialog
    MINIMAL_DIGITS = 3
    KEYBOARD = (3..6).to_a

    def call
      Fiber.new do |message|
        reply(I18n.t('game.hello', name: message.from.first_name))
        game = BullsCows::Game.new(digits: request_digits)
        attempt = request(I18n.t('game.guess'))
        attempt = wait until process_attempt(game, attempt).completed
        answer(I18n.t('game.final'))
      end
    end

    private

    def request_digits
      loop do
        answer = request(I18n.t('game.request'), variants: KEYBOARD).text.to_i
        break(answer) if answer >= MINIMAL_DIGITS
      end
    end

    def process_attempt(game, attempt)
      game.guess(attempt.text).tap do |result|
        reply(I18n.t('game.result', result.to_h.slice(:counter, :bulls, :cows)))
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
