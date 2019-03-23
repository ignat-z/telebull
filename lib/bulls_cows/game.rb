# frozen_string_literal: true

require './lib/bulls_cows/tick'
require './lib/bulls_cows/number'

module BullsCows
  class Game
    def initialize(number: nil, counter: 0, digits: 4)
      @number = number || Number.new(digits: digits).generate
      @counter = counter
    end

    def guess(user_number)
      Tick.new(@number, user_number)
          .guess(counter: @counter)
          .tap(&method(:persist))
    end

    attr_reader :counter

    private

    def persist(result)
      @counter = result.counter
    end
  end
end
