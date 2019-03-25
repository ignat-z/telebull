# frozen_string_literal: true

require 'spec_helper'
require './lib/telegram/game_workflow'

RSpec.describe Telegram::GameWorkflow do
  subject { described_class.new(keeper) }

  let(:dialog) { File.read('./spec/support/expected_dialog.txt') }
  let(:keeper) { LogKeeper.new }
  let(:answers) do
    dialog.split("\n")
          .filter { |line| line.start_with?(LogKeeper::USER_START) }
          .map { |line| line.sub(LogKeeper::USER_START, '') }
  end

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

    it 'tests it step by step' do
      dialog.split("\n").each do |line|
        if line.start_with?(LogKeeper::USER_START)
          subject.transfer!(keeper.answer(line.sub(LogKeeper::USER_START, '')))
        end
        expect(keeper.head).to eql(line)
      end
    end
  end
end
