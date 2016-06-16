module Payonline
  class Signature
    def initialize(params, keys = [])
      @keys = keys

      # The order of parameter keys matters
      @params = params.reverse_merge(merchant_id: Payonline.configuration.merchant_id)
      @keys.unshift(:merchant_id) if @keys.present?

      @params[:security_key] = digest
      @params[:content_type] = 'text'
    end

    def sign
      @params.transform_keys { |key| key.to_s.camelize }
    end

    def digest
      Digest::MD5.hexdigest(digest_data)
    end

    private

    def digest_data
      digest_params = @params.slice(*@keys) if @keys.present?
      digest_params[:private_security_key] = Payonline.configuration.private_security_key

      digest_params
        .transform_keys { |key| key.to_s.camelize }
        .map { |key, value| "#{key}=#{value}" }
        .join('&')
    end
  end
end
