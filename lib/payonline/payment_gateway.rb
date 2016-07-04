module Payonline
  class PaymentGateway
    SIGNED_PARAMS = %w(order_id amount currency valid_until order_description)
    BASE_URL = 'https://secure.payonlinesystem.com'

    REQUIRED_PARAMS = %w(
      order_id amount currency valid_until
      order_description return_url fail_url return_url
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
      params = Payonline::Signature.sign_params(@params, SIGNED_PARAMS)

      "#{BASE_URL}/#{language}/payment/#{PAYMENT_TYPE_URL[type]}?#{params.to_query}"
    end

    private

    def prepare_params(params)
      params.with_indifferent_access
        .slice(*REQUIRED_PARAMS)
        .merge(default_params)
        .merge(amount: '%.2f' % params[:amount])
    end

    def default_params
      {
        return_url: Payonline.configuration.return_url,
        fail_url: Payonline.configuration.fail_url
      }
    end
  end
end
