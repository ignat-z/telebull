# frozen_string_literal: true

require 'spec_helper'
require './lib/telegram/game_workflow'

RSpec.describe Telegram::GameWorkflow do
  subject { described_class.new(keeper) }
  include_examples :game_example
end
