# frozen_string_literal: true
require "spec_helper"

RSpec.describe RailsSessionCipher do
  it "has a version number" do
    expect(RailsSessionCipher::VERSION).not_to be nil
  end

  describe "encryption/decryption" do
    let(:data) { { "user_id" => 1 } }
    let(:key) { "12345678901234567890123456789012" }
    let(:iv) { "123456789012" }
    let(:auth_tag) { "1234567890123456" }

    it "encrypts and decrypts data" do
      encrypted_cookie = RailsSessionCipher.encrypt(
        data,
        Rails.application.secret_key_base,
        iv,
        auth_tag,
        Rails.configuration.active_support.hash_digest_class,
        Rails.configuration.action_dispatch.authenticated_encrypted_cookie_salt,
      )
      expect(encrypted_cookie).to be_a(String)
      expect(encrypted_cookie).to include("--")
      expect(encrypted_cookie).to include("==")

      decrypted_cookie = RailsSessionCipher.decrypt(encrypted_cookie)
      expect(decrypted_cookie).to eq(data)
    end
  end
end
