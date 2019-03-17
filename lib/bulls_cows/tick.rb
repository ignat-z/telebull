# frozen_string_literal: true

require './lib/bulls_cows/attempt'

module BullsCows
  class Tick
    def initialize(game_number, user_number)
      @user_number = user_number
      @user_digits = digits(user_number)
      @game_digits = digits(game_number)
    end

    def guess(attempt: 0)
      Attempt.new(@user_number, bulls, cows, (attempt + 1))
    end

    private

    def bulls
      @game_digits.zip(@user_digits).count do |(game_digit, user_digit)|
        game_digit == user_digit
      end
    end

    def cows
      (@game_digits & @user_digits).count - bulls
    end

    def digits(number)
      number.to_s.chars.map(&:to_i)
    end
  end
end
