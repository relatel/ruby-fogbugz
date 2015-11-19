require 'cgi'
require 'net/https'

module Fogbugz
  module Adapter
    module HTTP
      class NetHttp
        attr_accessor :root_url, :requester

        def initialize(options = {})
          @root_url = options[:uri]
          @ca_file = options[:ca_file]
        end

        def request(action, options)
          uri = URI("#{@root_url}/api.asp")

          params = { 'cmd' => action }
          params.merge!(options[:params])

          # build up the form request
          request = Net::HTTP::Post.new(uri.request_uri)
          request.set_form_data(params)

          http = Net::HTTP.new(uri.host, uri.port)
          if @root_url.start_with? 'https'
            http.use_ssl = true
            http.ca_file = @ca_file
          end

          response = http.start { |h| h.request(request) }
          response.body
        end
      end
    end
  end
end
