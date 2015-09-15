require 'cgi'
require 'net/https'

module Fogbugz
  module Adapter
    module HTTP
      class NetHttp
        attr_accessor :root_url, :requester

        def initialize(options = {})
          @root_url = options[:uri]
        end

        def request(action, options)
          uri = URI("#{@root_url}/api.asp")

          params = { 'cmd' => action }
          params.merge!(options[:params])

          # build up the form request
          request = Net::HTTP::Post.new(uri.request_uri)
          request.set_form_data(params)

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = @root_url.start_with? 'https'

          response = http.start { |h| h.request(request) }
          response.body
        end
      end
    end
  end
end
