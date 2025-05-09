# frozen_string_literal: true

require_relative './luhn_validator'
require 'json'
require 'rbnacl'

class CreditCard # rubocop:disable Style/Documentation
  include LuhnValidator

  # instance variables with automatic getter/setter methods
  attr_accessor :number, :expiration_date, :owner, :credit_network

  def initialize(number, expiration_date, owner, credit_network)
    @number = number
    @expiration_date = expiration_date
    @owner = owner
    @credit_network = credit_network
  end

  # returns json string
  def to_json(*_args)
    {
      number: @number,
      expiration_date: @expiration_date,
      owner: @owner,
      credit_network: @credit_network
    }.to_json
  end

  # returns all card information as single string
  def to_s
    to_json
  end

  # return a new CreditCard object given a serialized (JSON) representation
  def self.from_s(card_s)
    data = JSON.parse(card_s) # 解析 JSON 字串成 Hash
    CreditCard.new(data['number'], data['expiration_date'], data['owner'], data['credit_network'])
  end
  # TODO: deserializing a CreditCard object

  # return a hash of the serialized credit card object
  def hash
    to_json.hash
    # TODO: implement this method
    #   - Produce a hash (using default hash method) of the credit card's
    #     serialized contents.
    #   - Credit cards with identical information should produce the same hash
  end

  # return a cryptographically secure hash
  def hash_secure
    RbNaCl::Hash.sha256(to_json)
    # TODO: implement this method
    #   - Use sha256 to create a cryptographically secure hash.
    #   - Credit cards with identical information should produce the same hash
  end
end
