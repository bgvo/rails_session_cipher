require "benchmark"
require "rails"
require_relative "../lib/rails_session_cipher"

# Initialize dummy Rails application
require_relative "../spec/dummy/config/environment"

# Sample data and configuration
data = { "user_id" => 1 }
key = "12345678901234567890123456789012"
auth_tag = "1234567890123456"
iv = "123456789012"
options = {
  salt: Rails.configuration.action_dispatch.authenticated_encrypted_cookie_salt,
  hash_digest_class: Rails.configuration.active_support.hash_digest_class,
}

encrypted_data = RailsSessionCipher.encrypt(data, key, iv, auth_tag, options)

# Simulating 50 requests
n = 50

Benchmark.bmbm do |x|
  x.report("Encrypt:") do
    n.times { RailsSessionCipher.encrypt(data, key, iv, auth_tag, options) }
  end
  x.report("Decrypt:") do
    n.times { RailsSessionCipher.decrypt(encrypted_data, key, options) }
  end
end
