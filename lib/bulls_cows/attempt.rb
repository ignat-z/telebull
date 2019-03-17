# frozen_string_literal: true

module BullsCows
  Attempt = Struct.new(:guess, :bulls, :cows, :number) do
    def success?
      guess.to_s.size == bulls
    end
  end
end
