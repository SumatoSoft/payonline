require 'yaml'
require 'payonline/config'
require 'payonline/payment_gateway'
require 'payonline/payment_response'
require 'payonline/signature'

module Payonline
  extend self

  def self.configuration
    @configuration ||= Config.new
  end

  def self.config
    config = configuration
    yield(config)
  end
end
