module Payonline
  class Signature
    def self.digest(sign_params, keys=[])
      if keys.present?
        sign_params = sign_params.slice(*keys)
      end

      sign_params.merge!({ private_security_key: Payonline.configuration.private_security_key })
      Digest::MD5.hexdigest(sign_params.each.map{|k, v| "#{k.to_s.camelize}=#{v}"}.join('&'))
    end

    def self.sign_params(params, keys=[], add_merchant_id = true)
      params.reverse_merge!({ 'merchant_id' => Payonline.configuration.merchant_id }) if add_merchant_id
      if keys.present?
        keys.unshift 'merchant_id'  if add_merchant_id
      end
      digest = self.digest(params, keys)
      params.merge!({ 'security_key' => digest, 'content_type' => 'text' })

      params
    end
  end
end
