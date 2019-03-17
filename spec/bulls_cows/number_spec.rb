# frozen_string_literal: true

require 'spec_helper'
require './lib/bulls_cows/number'

RSpec.describe BullsCows::Number do
  subject { described_class.new(alphabet: short_alpha, pick: pick) }

  let(:pick) { ->(array) { array.first } }

  describe '#generate' do
    context 'with a small alphabet' do
      let(:short_alpha) { (1..4).to_a }

      it 'generates 4-digits number with all different digits' do
        expect(subject.generate).to eql(1234)
      end
    end

    context 'with a larger alphabet' do
      let(:short_alpha) { (1..9).to_a.reverse }

      it 'generates 4-digits number with all different digits' do
        expect(subject.generate).to eql(9876)
      end
    end
  end
end
