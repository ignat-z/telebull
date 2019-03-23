# frozen_string_literal: true

class LogKeeper
  Message = Struct.new(:text, :from)

  def initialize
    @log = []
    @from = Struct.new(:first_name).new('ZI')
  end

  attr_reader :log

  def answer(text)
    @log << "U: #{text}"
    Message.new(text, @from)
  end

  def print(attributes)
    @log << "B: #{attributes[:text]}"
  end

  def read
    @log.join("\n")
  end

  # def diff(expected)
  #   expected.split("\n").zip(@log).map do |(expected, actual)|
  #     [expected, actual].join("\n") unless expected == actual
  #   end.compact
  # end
end
