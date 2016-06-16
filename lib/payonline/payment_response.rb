module Payonline
  class PaymentResponse
    extend Forwardable

    attr_accessor :data, :params

    RESPONSE_PARAMS = %i(date_time transaction_id order_id amount currency)

    def_delegators :data, *RESPONSE_PARAMS

    def initialize(params = {})
      @params = prepare_params(params)
      @data = OpenStruct.new(@params)
    end

    def valid_payment?
      keys = RESPONSE_PARAMS.select { |key| @params.has_key?(key) }
      @params[:security_key] == Payonline::Signature.new(@params, keys, false).digest
    end

    private

    def prepare_params(params)
      params
        .transform_keys { |key| key.to_s.underscore }
        .with_indifferent_access
    end
  end
end
