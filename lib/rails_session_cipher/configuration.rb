module RailsSessionCipher
  module Configuration
    class Configuration
      attr_accessor :iteration_count, :hash_digest_class, :salt

      def initialize
        @iteration_count = 1000
        @hash_digest_class = Rails.configuration.active_support.hash_digest_class rescue nil
        @salt = Rails.configuration.action_dispatch.authenticated_encrypted_cookie_salt rescue nil
      end
    end

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
