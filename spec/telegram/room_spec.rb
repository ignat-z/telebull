# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'
require './lib/telegram/room'

RSpec.describe Telegram::Room do
  let(:chat_id) { [:chat_id, SecureRandom.hex(8)].join('_') }
  let(:token) { [:token, SecureRandom.hex(8)].join('_') }
  let(:text) { [:text, SecureRandom.hex(8)].join('_') }

  describe '#print' do
    context 'when the message is a simple text' do
      before do
        stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
          .with(body: {
                  'chat_id' => chat_id,
                  'text' => text
                })
          .to_return(body: {}.to_json)
      end

      it 'pass message to Telegram API' do
        with_client do |bot|
          described_class.new(bot, chat_id).print(text: text)
        end
      end
    end

    context 'when the message is a text with choose variants' do
      before do
        stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
          .with(body: {
                  'chat_id' => chat_id,
                  'text' => text,
                  'reply_markup' => {
                    'keyboard' => [['1'], ['2']],
                    'resize_keyboard' => false,
                    'one_time_keyboard' => true,
                    'selective' => false
                  }.to_json
                })
          .to_return(body: {}.to_json)
      end

      it 'pass message to Telegram API and wraps variants' do
        with_client do |bot|
          described_class.new(bot, chat_id).print(text: text, variants: [1, 2])
        end
      end
    end

    private

    def with_client
      Telegram::Bot::Client.run(token) { |bot| yield(bot) }
    end
  end
end
