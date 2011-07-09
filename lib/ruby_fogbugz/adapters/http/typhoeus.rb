require 'typhoeus'

module Fogbugz
  module Adapter
    module HTTP
      class Typhoeuser
        attr_reader :uri

        def initialize(uri)
          @uri = uri
        end

        def get(params = {})
          handle_response request(:get, params)
        end

        def post(data = {})
          handle_response request(:post, data)
        end

        private
        def request(method, data)
          Typhoeus::Request.send(method, @uri, :params => data)
        end

        def handle_response(response)
          return response.body if response.success?
          msg = 'Unknown request error'
          if response.timed_out?
            msg = "Request timed out"
          elsif response.code == 0
            msg = response.curl_error_message
          else
            msg = "Request failed: %s" % response.code
          end
          raise Fogbugz::RequestError, msg
        end
      end
    end
  end
end
