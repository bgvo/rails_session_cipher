# frozen_string_literal: true

require_relative "rails_session_cipher/version"
require_relative "rails_session_cipher/configuration"
require "base64"
require "openssl"

module RailsSessionCipher
  class InvalidMessage < StandardError; end

  class << self
    include Configuration

    def encrypt(data, key, iv, auth_tag, hash_digest_class, salt)
      # Convert data to JSON
      json_data = data.to_json

      # Key generation with PBKDF2
      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      secret = OpenSSL::PKCS5.pbkdf2_hmac(key, salt, 1000, cipher.key_len, hash_digest_class.new)

      # Initialize cipher for encryption
      cipher.encrypt
      cipher.key = secret
      iv = cipher.random_iv
      cipher.iv = iv
      cipher.auth_data = ""

      # Encrypt the data
      encrypted_data = cipher.update(json_data) + cipher.final
      auth_tag = cipher.auth_tag

      # Encode and concatenate components
      [Base64.strict_encode64(encrypted_data), Base64.strict_encode64(iv), Base64.strict_encode64(auth_tag)].join("--")
    end

    def decrypt(session_cookie)
      data, iv, auth_tag = session_cookie&.split("--")&.map { |v| Base64.strict_decode64(v) }
      raise InvalidMessage if (auth_tag.nil? || auth_tag.bytes.length != 16)

      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      secret = OpenSSL::PKCS5.pbkdf2_hmac(
        Rails.application.secret_key_base,
        Rails.configuration.action_dispatch.authenticated_encrypted_cookie_salt,
        1000,
        cipher.key_len,
        Rails.configuration.active_support.hash_digest_class.new
      )

      # Setup cipher for decryption and add inputs
      cipher.decrypt
      cipher.key = secret
      cipher.iv = iv
      cipher.auth_tag = auth_tag
      cipher.auth_data = ""

      # Perform decryption
      cookie_payload = cipher.update(data)
      cookie_payload << cipher.final
      JSON.parse(cookie_payload)
    rescue InvalidMessage
      {}
    end
  end
end
