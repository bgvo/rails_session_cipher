# frozen_string_literal: true

require_relative "rails_session_cipher/version"
require_relative "rails_session_cipher/configuration"
require "base64"
require "openssl"

module RailsSessionCipher
  extend Configuration

  class InvalidMessage < StandardError; end

  class << self
    def encrypt(data, key, iv, auth_tag, options = {})
      json_data = data.to_json
      cipher, secret = initialize_cipher(key, options, "encrypt")

      cipher.encrypt
      cipher.key = secret
      iv = cipher.random_iv
      cipher.iv = iv
      cipher.auth_data = ""

      encrypted_data = cipher.update(json_data) + cipher.final
      auth_tag = cipher.auth_tag

      [Base64.strict_encode64(encrypted_data), Base64.strict_encode64(iv), Base64.strict_encode64(auth_tag)].join("--")
    end

    def decrypt(session_cookie, key, options = {})
      data, iv, auth_tag = session_cookie&.split("--")&.map { |v| Base64.strict_decode64(v) }
      raise InvalidMessage if (auth_tag.nil? || auth_tag.bytes.length != 16)

      cipher, secret = initialize_cipher(key, options, "decrypt")

      cipher.decrypt
      cipher.key = secret
      cipher.iv = iv
      cipher.auth_tag = auth_tag
      cipher.auth_data = ""

      cookie_payload = cipher.update(data)
      cookie_payload << cipher.final
      JSON.parse(cookie_payload)
    rescue InvalidMessage
      {}
    end

    private

    def initialize_cipher(key, options, mode)
      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      iteration_count = configuration.iteration_count
      salt = options[:salt] || configuration.salt
      hash_digest_class = options[:hash_digest_class] || configuration.hash_digest_class
      secret = OpenSSL::PKCS5.pbkdf2_hmac(key, salt, iteration_count, cipher.key_len, hash_digest_class.new)
      [cipher, secret]
    end
  end
end
