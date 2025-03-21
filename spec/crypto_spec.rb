# frozen_string_literal: true

require_relative '../credit_card'
require_relative '../substitution_cipher'
require_relative '../double_trans_cipher'
require_relative '../sk_cipher'
require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'base64'

describe 'Test card info encryption' do
  before do
    @cc = CreditCard.new('4916603231464963', 'Mar-30-2020',
                         'Soumya Ray', 'Visa')
    @keys = [3, 100, 114_514, 1_919_810, 1_145_141_919_810, 2_147_483_647]
  end

  ciphers = [SubstitutionCipher::Caesar, SubstitutionCipher::Permutation, DoubleTranspositionCipher]

  ciphers.each do |cipher|
    describe "Using #{cipher}" do
      it 'should encrypt card information' do
        @keys.each do |key|
          enc = cipher.encrypt(@cc.to_s, key)
          _(enc).wont_equal @cc.to_s
          _(enc).wont_be_nil
        end
      end

      it 'should decrypt text' do
        @keys.each do |key|
          enc = cipher.encrypt(@cc.to_s, key)
          dec = cipher.decrypt(enc, key)
          _(dec).must_equal @cc.to_s
        end
      end
    end
  end
end

describe 'Test card info encryption on sk-cipher' do
  before do
    card_details = YAML.load_file 'spec/test_cards.yml'
    @cards = card_details.map do |c|
      CreditCard.new(c['num'], c['exp'], c['name'], c['net'])
    end
  end

  it 'should generate new base64 keys' do
    @cards.map do
      key = ModernSymmetricCipher.generate_new_key
      _(key).wont_be_nil

      # Check if key is a Base64 string
      _(Base64.strict_encode64(Base64.strict_decode64(key))).must_equal key
    end
  end

  it 'should encrypt card information' do
    @cards.each do |card|
      key = ModernSymmetricCipher.generate_new_key
      enc = ModernSymmetricCipher.encrypt(card.to_s, key)
      _(enc).wont_equal card.to_s
      _(enc).wont_equal Base64.strict_encode64(card.to_s)
      _(enc).wont_be_nil

      # Check if enc is a Base64 string
      _(Base64.strict_encode64(Base64.strict_decode64(enc))).must_equal enc
    end
  end

  it 'should decrypt card information' do
    @cards.each do |card|
      key = ModernSymmetricCipher.generate_new_key
      enc = ModernSymmetricCipher.encrypt(card.to_s, key)
      dec = ModernSymmetricCipher.decrypt(enc, key)
      _(dec).must_equal card.to_s
    end
  end
end
