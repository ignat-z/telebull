# frozen_string_literal: true

module Telegram
  class DialogActor
    UnknownStateError = Class.new(StandardError)
    ImpossibeTransition = Class.new(StandardError)

    NEW_CHAT            = :NEW_CHAT
    AFTER_STATEMENT     = :AFTER_STATEMENT
    WAITING_FOR_REPLY   = :WAITING_FOR_REPLY
    AFTER_REPLY         = :AFTER_REPLY
    FINAL_STATE         = :FINAL_STATE

    TRANSITIONS = {
      finish: [[AFTER_REPLY, AFTER_STATEMENT], FINAL_STATE],
      reply: [[NEW_CHAT, WAITING_FOR_REPLY, FINAL_STATE], AFTER_REPLY],
      ask: [[NEW_CHAT, AFTER_REPLY, AFTER_STATEMENT], WAITING_FOR_REPLY],
      say: [[NEW_CHAT, AFTER_REPLY, AFTER_STATEMENT], AFTER_STATEMENT]
    }.freeze

    def initialize(state: NEW_CHAT)
      @state = state
    end

    def act(action)
      from, to = fetch(action)
      ensure_valid_transition!(from, to)
      yield if block_given?
      @state = to
    end

    TRANSITIONS.keys.each do |action_method|
      define_method(action_method) do |&block|
        act(action_method) { block&.call }
      end
    end

    attr_reader :state

    private

    def ensure_valid_transition!(from, to)
      return if from.include?(@state)

      raise ImpossibeTransition, "No transition: #{@state} -> #{to}"
    end

    def fetch(action)
      TRANSITIONS.fetch(action) do
        raise UnknownStateError, "Can't handle #{action} state"
      end
    end
  end
end
