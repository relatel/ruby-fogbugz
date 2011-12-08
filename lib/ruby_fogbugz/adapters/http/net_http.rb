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
          # Convert the hash key/values to key=value&key2=value2 strings - CGI escaping along the way
          options_string = options[:params].map{ |k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join('&')
          
          url_string = "#{@root_url}/api.asp?cmd=#{action}&#{options_string}"
          url = URI.parse(url_string)
          
          request = Net::HTTP::Get.new(url_string, {"Content-Type"=>"text/xml"})
          
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = @root_url.start_with? 'https'
          
          response = http.start {|http| http.request(request) }
          response.body
        end
      end
    end
  end
end
