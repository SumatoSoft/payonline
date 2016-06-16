module Payonline
  class RebillGateway
    SIGNED_PARAMS = %w(rebill_anchor order_id amount currency)
    PERMITTED_PARAMS = %w(rebill_anchor order_id amount currency)
    BASE_URL = 'https://secure.payonlinesystem.com'

    def initialize(params = {})
      @params = prepare_params(params)
    end

    # Perform the rebill operation and return the response
    def rebill
      response = HTTParty.get(rebill_url)
      return false unless response.success?

      Payonline::RebillResponse.new(response.body).success?
    end

    # Return the URL without performing a request
    def rebill_url
      params = Payonline::Signature.new(@params, SIGNED_PARAMS).sign

      "#{BASE_URL}/payment/transaction/rebill/?#{params.to_query}"
    end

    private

    def prepare_params(params)
      params
        .with_indifferent_access
        .slice(*PERMITTED_PARAMS)
        .merge(default_params)
        .merge(amount: format('%.2f', params[:amount]))
    end

    def default_params
      {}
    end
  end
end
