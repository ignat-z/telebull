# frozen_string_literal: true

require './lib/bulls_cows/attempt'

module BullsCows
  class Tick
    def initialize(game_number, user_number)
      @user_number = user_number
      @user_digits = digits(user_number)
      @game_digits = digits(game_number)
    end

    def guess(counter: 0)
      Attempt.new(@user_number, bulls, cows, (counter + 1), completed?)
    end

    private

    def completed?
      @user_digits == @game_digits
    end

    def bulls
      @game_digits.zip(@user_digits).count do |(game_digit, user_digit)|
        game_digit == user_digit
      end
    end

    def cows
      (@game_digits & @user_digits).count - bulls
    end

    def digits(number)
      number.to_s.chars
    end
  end
end
