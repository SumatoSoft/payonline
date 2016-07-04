module Payonline
  class Signature
    def self.digest(sign_params, keys = [])
      sign_params = sign_params.slice(*keys) if keys.present?

      sign_params[:private_security_key] = Payonline.configuration.private_security_key
      Digest::MD5.hexdigest(sign_params.each.map { |k, v| "#{k.to_s.camelize}=#{v}" }.join('&'))
    end

    def self.sign_params(params, keys = [], add_merchant_id = true)
      params.reverse_merge!('merchant_id' => Payonline.configuration.merchant_id) if add_merchant_id
      keys.unshift 'merchant_id' if keys.present? && add_merchant_id
      digest = self.digest(params, keys)
      params['security_key'] = digest
      params['content_type'] = 'text'

      params
    end
  end
end
