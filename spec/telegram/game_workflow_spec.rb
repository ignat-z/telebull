# frozen_string_literal: true

require 'spec_helper'
require './lib/telegram/game_workflow'

RSpec.describe Telegram::GameWorkflow do
  subject { described_class.new(keeper) }

  let(:keeper) { LogKeeper.new }
  let(:answers) { ['/start', '4', '1290', '3478', '3412', '1234'] }
  let(:dialog) { File.read('./spec/support/expected_dialog.txt') }

  describe 'workflow' do
    before do
      stub_const('Telegram::GameWorkflow::KEYBOARD', (1..4))
      expect(BullsCows::Game).to receive(:new).and_return(
        BullsCows::Game.new(number: 1234)
      )
    end

    it 'provides game workflow' do
      answers.each { |message| subject.transfer!(keeper.answer(message)) }
      aggregate_failures do
        keeper.log.zip(dialog.split("\n")).each do |(actual, expected)|
          expect(actual).to eql(expected)
        end
      end
    end
  end
end
