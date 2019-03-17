# frozen_string_literal: true

module BullsCows
  class Number
    DEFAULT_ALPHABET = (0..9).to_a
    DIGITS = 4
    PICK = ->(array) { array.sample }

    def initialize(alphabet: DEFAULT_ALPHABET, pick: PICK, digits: DIGITS)
      @alphabet = alphabet
      @pick = pick
      @digits = digits
    end

    def generate
      @digits.times.inject([@alphabet, []]) do |(alpha, result), _i|
        sample = @pick.call(alpha)
        [alpha - [sample], result + [sample]]
      end.last.join.to_i
    end
  end
end
