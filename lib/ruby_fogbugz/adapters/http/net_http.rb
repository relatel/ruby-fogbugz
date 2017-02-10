require 'cgi'
require 'net/https'
require 'net/http/post/multipart'

module Fogbugz
  module Adapter
    module HTTP
      class NetHttp
        attr_accessor :root_url, :requester

        def initialize(options = {})
          @root_url = options[:uri]
          @ca_file = options[:ca_file]
        end

        def build_request(uri, params)
          return Net::HTTP::Post::Multipart.new(uri.request_uri, params) if params.key? :File1

          request = Net::HTTP::Post.new(uri.request_uri)
          request.set_form_data(params)
          request
        end

        def request(action, options)
          uri = URI("#{@root_url}/api.asp")

          params = { 'cmd' => action }
          params.merge!(options[:params])

          request = build_request(uri, params)

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
