# frozen_string_literal: true

module BullsCows
  class Number
    TooLargeNumber = Class.new(StandardError)
    DEFAULT_ALPHABET = (0..9).to_a
    DIGITS = 4

    def initialize(alphabet: DEFAULT_ALPHABET, digits: DIGITS)
      @alphabet = alphabet
      @digits = digits
      ensure_correctness!
    end

    def generate
      @alphabet.sample(@digits).join
    end

    private

    def ensure_correctness!
      return unless @digits > @alphabet.size

      raise TooLargeNumber, 'Alphabet is too short for this number'
    end
  end
end
