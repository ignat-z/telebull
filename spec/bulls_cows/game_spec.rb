# frozen_string_literal: true

require 'spec_helper'
require './lib/bulls_cows/game'

RSpec.describe BullsCows::Game do
  subject { described_class.new(number: 1234) }

  let(:tick) { instance_double(BullsCows::Tick) }
  let(:attempt) { instance_double(BullsCows::Attempt, counter: 42) }

  describe '#guess' do
    it 'delegates logic to Tick and persists values' do
      expect(BullsCows::Tick).to receive(:new).with(1234, 2134).and_return(tick)
      expect(tick).to receive(:guess).and_return(attempt)

      expect(subject.guess(2134)).to equal(attempt)
      expect(subject.counter).to eql(42)
    end
  end

  it 'implements whole game process' do
    expect(subject.guess(5678)).to have_attributes(cows: 0, bulls: 0)
    expect(subject.guess(2134)).to have_attributes(cows: 2, bulls: 2)
    expect(subject.guess(2143)).to have_attributes(cows: 4, bulls: 0)
    expect(
      subject.guess(1234)
    ).to have_attributes(cows: 0, bulls: 4, counter: 4, completed: true)
  end
end
