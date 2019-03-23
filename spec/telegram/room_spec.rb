# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'
require './lib/telegram/room'

RSpec.describe Telegram::Room do
  let(:chat_id) { [:chat_id, SecureRandom.hex(8)].join('_') }
  let(:token) { [:token, SecureRandom.hex(8)].join('_') }
  let(:text) { [:text, SecureRandom.hex(8)].join('_') }

  describe '#print' do
    before do
      stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
        .with(body: { 'chat_id' => chat_id, 'text' => text })
        .to_return(body: {}.to_json)
    end

    it 'delegates attributes to send_message telegram method' do
      Telegram::Bot::Client.run(token) do |bot|
        described_class.new(bot, chat_id).print(text: text)
      end
    end
  end
end
