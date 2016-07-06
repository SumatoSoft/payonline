require 'active_support/all'
require 'httparty'

require 'payonline/config'
require 'payonline/payment_gateway'
require 'payonline/payment_response'
require 'payonline/rebill_gateway'
require 'payonline/rebill_response'
require 'payonline/signature'

module Payonline
  def self.configuration
    @configuration ||= Config.new
  end

  def self.config
    config = configuration
    yield(config)
  end
end
