# frozen_string_literal: true

require 'spec_helper'
require './lib/bulls_cows/attempt'

RSpec.describe BullsCows::Attempt do
  describe '#success?' do
    it 'returns true for all bulls' do
      expect(described_class.new(1234, 4, 0, 0)).to be_success
    end

    it 'returns false otherwise' do
      expect(described_class.new(1234, 3, 1, 0)).not_to be_success
    end
  end
end
