# frozen_string_literal: true

require_relative '../credit_card'
require_relative '../substitution_cipher'
require_relative '../double_trans_cipher'
require 'minitest/autorun'

describe 'Test card info encryption' do
  before do
    @cc = CreditCard.new('4916603231464963', 'Mar-30-2020',
                         'Soumya Ray', 'Visa')
    @key = 3
  end

  ciphers = [SubstitutionCipher::Caesar, SubstitutionCipher::Permutation, DoubleTranspositionCipher]

  ciphers.each do |cipher|
    describe "Using #{cipher}" do
      it 'should encrypt card information' do
        enc = cipher.encrypt(@cc.to_s, @key)
        _(enc).wont_equal @cc.to_s
        _(enc).wont_be_nil
      end

      it 'should decrypt text' do
        enc = cipher.encrypt(@cc.to_s, @key)
        dec = cipher.decrypt(enc, @key)
        _(dec).must_equal @cc.to_s
      end
    end
  end
end
