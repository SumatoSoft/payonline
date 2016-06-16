module Payonline
  class PaymentResponse
    extend Forwardable

    attr_accessor :response, :params

    RESPONSE_PARAMS = %w(date_time transaction_id order_id amount currency)

    def_delegators :params, *RESPONSE_PARAMS

    def initialize(response = {})
      self.response = response
      self.params = OpenStruct.new(normalize_params)
    end

    def valid_payment?
      keys = RESPONSE_PARAMS.each_with_object([]).each do |key, array|
        array << response.keys.find { |e| e.underscore == key }
      end

      params.security_key == Payonline::Signature.digest(response, keys)
    end

    private

    def normalize_params
      response
        .with_indifferent_access
        .transform_keys { |key| key.to_s.underscore }
    end
  end
end
