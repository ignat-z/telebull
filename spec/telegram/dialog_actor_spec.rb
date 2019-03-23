# frozen_string_literal: true

require 'spec_helper'
require './lib/telegram/dialog_actor'

RSpec.describe Telegram::DialogActor do
  subject { described_class.new(state: described_class::WAITING_FOR_REPLY) }

  describe '#act' do
    let(:dummy_action) { double(:action) }

    it 'allows to change dialog state by actions' do
      expect(subject.act(:reply)).to eql(described_class::AFTER_REPLY)
    end

    it 'allows to make some actions in context of change' do
      expect(dummy_action).to receive(:call)
      subject.act(:reply) { dummy_action.call }
    end

    it 'allows to call transitions by their names' do
      expect(dummy_action).to receive(:call)
      subject.reply { dummy_action.call }
      subject.ask
    end

    it 'denies impossible transitions' do
      expect do
        subject.act(:ask)
      end.to raise_error(described_class::ImpossibeTransition)
    end

    it 'raises for unknown state changes' do
      expect do
        subject.act(:task)
      end.to raise_error(described_class::UnknownStateError)
    end
  end
end
