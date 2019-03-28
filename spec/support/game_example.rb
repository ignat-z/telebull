# frozen_string_literal: true

RSpec.shared_examples :game_example do
  let(:dialog) { File.read('./spec/support/expected_dialog.txt') }
  let(:keeper) { LogKeeper.new }
  let(:answers) do
    dialog.split("\n")
          .filter { |line| line.start_with?(LogKeeper::USER_START) }
          .map { |line| line.sub(LogKeeper::USER_START, '') }
  end

  describe 'fiber' do
    before do
      stub_const('Telegram::GameFiber::KEYBOARD', (1..4))
      expect(BullsCows::Game).to receive(:new).and_return(
        BullsCows::Game.new(number: 1234)
      )
    end

    it 'provides game fiber' do
      answers.each { |message| subject.call(keeper.answer(message)) }
      aggregate_failures do
        keeper.log.zip(dialog.split("\n")).each do |(actual, expected)|
          expect(actual).to eql(expected)
        end
      end
    end

    it 'tests it step by step' do
      dialog.split("\n").each do |line|
        if line.start_with?(LogKeeper::USER_START)
          subject.call(keeper.answer(line.sub(LogKeeper::USER_START, '')))
        end
        expect(keeper.head).to eql(line)
      end
    end
  end
end
