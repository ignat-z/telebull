# frozen_string_literal: true

module BullsCows
  Attempt = Struct.new(:guess, :bulls, :cows, :counter, :completed)
end
