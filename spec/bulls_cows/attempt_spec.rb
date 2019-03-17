# frozen_string_literal: true

require 'spec_helper'
require './lib/bulls_cows/attempt'

RSpec.describe BullsCows::Attempt do
  it 'describes attempt details' do
    expect(
      described_class.new
    ).to have_attributes(
      guess: nil, bulls: nil, cows: nil, counter: nil, completed: nil
    )
  end
end
