module Payonline
  class Config
    include ActiveSupport::Configurable

    config_accessor :merchant_id, :private_security_key, :return_url, :fail_url

    def initialize(options = {})
      options.each do |key, value|
        config.send("#{key}=", value)
      end
    end
  end
end
