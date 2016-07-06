module Payonline
  class RebillResponse
    SUCCESS_CODE = 'OK'

    def initialize(response)
      @response = parse_response(response)
    end

    def success?
      @response[:result] == SUCCESS_CODE
    end

    def failure?
      !success?
    end

    private

    def parse_response(response)
      CGI.parse(response)
        .transform_keys { |key| key.to_s.underscore }
        .transform_values(&:first)
        .with_indifferent_access
    end
  end
end
