# frozen_string_literal: true

require 'spec_helper'
require './lib/bulls_cows/number'

RSpec.describe BullsCows::Number do
  subject { described_class.new(alphabet: short_alpha) }

  describe '#generate' do
    context 'with a small alphabet' do
      let(:short_alpha) { (1..4).to_a }

      it 'generates 4-digits number with all different digits' do
        number = subject.generate
        expect(number.chars.uniq.length).to eq(4)
        expect(number.chars.map(&:to_i).sort).to eq(short_alpha)
      end
    end
  end

  context 'on too big digits number' do
    it 'raises error' do
      expect do
        described_class.new(alphabet: [], digits: 1)
      end.to raise_error(BullsCows::Number::TooLargeNumber)
    end
  end
end
