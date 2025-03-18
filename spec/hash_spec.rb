# frozen_string_literal: true

require_relative '../credit_card'
require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

card_details = YAML.load_file 'spec/test_cards.yml'

cards = card_details.map do |c|
  CreditCard.new(c["num"], c["exp"], c["name"], c["net"])
end

describe 'Test hashing requirements' do
  describe 'Check hashes are consistently produced' do
    # Check that each card produces the same hash if hashed repeatedly
    cards.each do |card|
      it 'should produce the same hash if hashed repeatedly' do
        hash1 = card.hash
        _(hash1).wont_be_nil

        hash2 = card.hash
        _(hash2).must_equal hash1
      end
    end
  end

  describe 'Check for unique hashes' do
    # Check that each card produces a different hash than other cards
    cards.combination(2).each do |card1, card2|
      it 'should produce a different hash than other cards' do
        _(card1.hash).wont_equal card2.hash
      end
    end
  end
end
