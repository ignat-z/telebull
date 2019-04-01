# frozen_string_literal: true

class LogKeeper
  Message = Struct.new(:text, :from)
  USER_START = 'U: '
  BOT_START = 'B: '
  NAME = 'ZI'

  def initialize
    @log = []
    @buffer = []
    @from = Struct.new(:first_name).new(NAME)
  end

  attr_reader :log

  def answer(text)
    result = [USER_START, text].join
    @log << result
    @buffer << result
    Message.new(text, @from)
  end

  def print(attributes)
    result = [
      BOT_START,
      attributes[:text],
      *(" [#{attributes[:variants].join(' ')}]" if attributes[:variants])
    ].join
    @buffer << result
    @log << result
  end

  def head
    @buffer.shift
  end

  def read
    @log.join("\n")
  end
end
