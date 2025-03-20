# frozen_string_literal: true

require 'rbnacl'
require 'base64'

# SK Cipher module
module ModernSymmetricCipher
  def self.generate_new_key
    # TODO: Return a new key as a Base64 string
    key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    Base64.strict_encode64(key)
  end

  def self.encrypt(document, key)
    # TODO: Return an encrypted string
    #       Use base64 for ciphertext so that it is sendable as text

    # Create a SecretBox with the key
    decoded_key = Base64.strict_decode64(key)
    secret_box = RbNaCl::SecretBox.new(decoded_key)
    # Generate a random nonce
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
    # Encrypt the document
    ciphertext = secret_box.encrypt(nonce, document)

    # Combine nonce and ciphertext, then encode to Base64
    encrypted_cc = nonce + ciphertext
    Base64.strict_encode64(encrypted_cc)
  end

  def self.decrypt(encrypted_cc, key)
    # TODO: Decrypt from encrypted message above
    #       Expect Base64 encrypted message and Base64 key

    # Decode the Base64 strings
    decoded_key = Base64.strict_decode64(key)
    decoded_message = Base64.strict_decode64(encrypted_cc)

    # Create a SecretBox with the key
    secret_box = RbNaCl::SecretBox.new(decoded_key)

    # Extract nonce and ciphertext
    nonce = decoded_message[0, secret_box.nonce_bytes]
    ciphertext = decoded_message[secret_box.nonce_bytes..-1]

    # Decrypt and return the message
    secret_box.decrypt(nonce, ciphertext)
  end
end
