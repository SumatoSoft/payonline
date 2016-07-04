module Payonline
  class PaymentGateway
    class Params < SimpleDelegator
      REQUIRED_PARAMS = %w(
        order_id amount currency valid_until
        order_description return_url fail_url return_url
      )

      def initialize(params)
        @params = prepare_params(params)

        filter_params

        __setobj__ @params
      end

      def to_query
        @params.each_with_object({}) do |(k, v), params|
          params[k.camelize] = v
        end.to_query
      end

      private

      def prepare_params(params)
        params[:amount] = '%.2f' % params[:amount]

        params.merge(
          return_url: Payonline.configuration.return_url,
          fail_url: Payonline.configuration.fail_url
        )
      end

      def filter_params
        @params.select! { |key, value| REQUIRED_PARAMS.include?(key) && value }
      end
    end

    SIGNED_PARAMS = %w(order_id amount currency valid_until order_description)
    BASE_URL = 'https://secure.payonlinesystem.com'
    PAYMENT_TYPE_URL = {
      qiwi: 'select/qiwi/',
      webmoney: 'select/webmoney/',
      yandexmoney: 'select/yandexmoney/'
    }

    def initialize(params = {})
      @params = Params.new(params.with_indifferent_access)
    end

    def payment_url(type: :card, language: :ru)
      params = Payonline::Signature.sign_params(@params, SIGNED_PARAMS)

      "#{BASE_URL}/#{language}/payment/#{PAYMENT_TYPE_URL[type]}?#{params.to_query}"
    end
  end
end
