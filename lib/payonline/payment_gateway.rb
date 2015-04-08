module Payonline
  class PaymentGateway
    class Params < SimpleDelegator

      REQUIED_PARAMS = %w(order_id amount currency valid_until order_description return_url fail_url return_url)

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

        default_params = { return_url: return_url, fail_url: fail_url }
        params.merge(default_params)
      end

      def filter_params
        @params.select! { |k, v| REQUIED_PARAMS.include?(k) && v }
      end

      def return_url
        @return_url ||= Payonline.configuration.return_url
      end

      def fail_url
        @fail_url ||= Payonline.configuration.fail_url
      end
    end

    SIGNED_PARAMS = %w(order_id amount currency valid_until order_description)

    def initialize(params={})
      @params = Params.new(params.with_indifferent_access)
    end

    def get_payment_url(type = 'card')
      params = Payonline::Signature.sign_params(@params, SIGNED_PARAMS)

      "#{url_by_kind_of_payment(type)}?#{params.to_query}"
    end

    private

    def url_by_kind_of_payment(type, language = 'ru')
      case type.to_s
        when 'qiwi'
          "https://secure.payonlinesystem.com/#{language}/payment/select/qiwi/"
        when 'webmoney'
          "https://secure.payonlinesystem.com/#{language}/payment/select/webmoney/"
        when 'yandexmoney'
          "https://secure.payonlinesystem.com/#{language}/payment/select/webmoney/"
        when 'card'
          "https://secure.payonlinesystem.com/#{language}/payment/"
      end
    end
  end
end
