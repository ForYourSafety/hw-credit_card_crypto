# frozen_string_literal: true

require_relative '../credit_card'
require 'minitest/autorun'
require 'minitest/rg'

# Feel free to replace the contents of cards with data from your own yaml file
card_details = [
  { num: '4916603231464963',
    exp: 'Mar-30-2020',
    name: 'Soumya Ray',
    net: 'Visa' },
  { num: '6011580789725897',
    exp: 'Sep-30-2020',
    name: 'Nick Danks',
    net: 'Visa' },
  { num: '5423661657234057',
    exp: 'Feb-30-2020',
    name: 'Lee Chen',
    net: 'Mastercard' }
]

cards = card_details.map do |c|
  CreditCard.new(c[:num], c[:exp], c[:name], c[:net])
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
