# frozen_string_literal: true

require 'spec_helper'
require './lib/bulls_cows/tick'

RSpec.describe BullsCows::Tick do
  subject { described_class.new(1234, 2134) }

  describe '#guess' do
    it "calculates user's input result" do
      expect(
        subject.guess(counter: 0)
      ).to have_attributes(cows: 2, bulls: 2, counter: 1)
    end

    it 'calculates number of bulls as a match digits-on-place count' do
      expect(subject.guess(counter: 0).bulls).to eql(2)
    end

    it 'calculates number of cows as a match digits-non-on-place count' do
      expect(subject.guess(counter: 0).cows).to eql(2)
    end

    it 'always increments attempts count' do
      expect(subject.guess(counter: 42).counter).to eql(43)
    end

    it "stores user's input" do
      expect(subject.guess(counter: 0).guess).to eql(2134)
    end
  end
end
