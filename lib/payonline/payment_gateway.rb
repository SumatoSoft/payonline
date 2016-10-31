module Payonline
  class PaymentGateway
    BASE_URL = 'https://secure.payonlinesystem.com'

    SIGNED_PARAMS = %w(order_id amount currency valid_until order_description)
    PERMITTED_PARAMS = %w(
      order_id amount currency valid_until order_description return_url fail_url
    )

    PAYMENT_TYPE_URL = {
      qiwi: 'select/qiwi/',
      webmoney: 'select/webmoney/',
      yandexmoney: 'select/yandexmoney/',
      masterpass: 'select/masterpass/'
    }

    def initialize(params = {})
      @params = prepare_params(params)
    end

    def payment_url(type: :card, language: :ru)
      params = Payonline::Signature.new(@params, SIGNED_PARAMS).sign

      "#{BASE_URL}/#{language}/payment/#{PAYMENT_TYPE_URL[type]}?#{params.to_query}"
    end

    private

    def prepare_params(params)
      params
        .with_indifferent_access
        .slice(*PERMITTED_PARAMS)
        .merge(default_params){ |_, important, _| important }
        .merge(amount: format('%.2f', params[:amount]))
    end

    def default_params
      {
        return_url: Payonline.configuration.return_url,
        fail_url: Payonline.configuration.fail_url
      }
    end
  end
end
