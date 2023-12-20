# frozen_string_literal: true
require "spec_helper"

RSpec.describe RailsSessionCipher do
  it "has a version number" do
    expect(RailsSessionCipher::VERSION).not_to be nil
  end

  describe "RailsSessionCipher" do
    let(:data) { { "user_id" => 1 } }
    let(:key) { "12345678901234567890123456789012" }
    let(:iv) { "123456789012" }
    let(:auth_tag) { "1234567890123456" }

    let(:encrypted_cookie) {
      RailsSessionCipher.encrypt(
        data,
        Rails.application.secret_key_base,
        iv,
        auth_tag
      )
    }

    let(:key) { Rails.application.secret_key_base }

    it "encrypts and decrypts data" do
      expect(encrypted_cookie).to be_a(String)
      expect(encrypted_cookie).to include("--")
      expect(encrypted_cookie).to include("==")

      decrypted_cookie = RailsSessionCipher.decrypt(encrypted_cookie, key)
      expect(decrypted_cookie).to eq(data)
    end

    it "encrypts and decrypts data passing salt and hash_digest_class as options" do
      expect(encrypted_cookie).to be_a(String)
      expect(encrypted_cookie).to include("--")
      expect(encrypted_cookie).to include("==")

      hash_digest_class = Rails.configuration.active_support.hash_digest_class
      salt = Rails.configuration.action_dispatch.authenticated_encrypted_cookie_salt

      decrypted_cookie = RailsSessionCipher.decrypt(encrypted_cookie, key,
                                                    salt: salt,
                                                    hash_digest_class: hash_digest_class)
      expect(decrypted_cookie).to eq(data)
    end
  end

  describe "configuration" do
    it "allows configuration of iteration_count" do
      RailsSessionCipher.configure do |config|
        config.iteration_count = 10000
      end

      expect(RailsSessionCipher.configuration.iteration_count).to eq(10000)
    end
  end
end
