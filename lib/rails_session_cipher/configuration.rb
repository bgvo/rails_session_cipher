module RailsSessionCipher
  module Configuration
    class Configuration
      attr_accessor :secret_key_base, :authenticated_encrypted_cookie_salt, :hash_digest_class
    end

    class << self
      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
      end
    end
  end
end
