require 'net/https'

module Fogbugz
  module Adapter
    module HTTP
      class NetHttp
        attr_accessor :uri, :requester

        def initialize(options = {})
          @uri = options[:uri]
          # @requester = Typhoeus::Request
        end

        def request(action, options)
          # params = {:cmd => action}.merge(options[:params])
          # query = @requester.get("#{uri}/api.asp", :params => params)
          options_string = options[:params].map{ |k,v| "#{k}=#{v}"}.join('&')
          url_string = "#{@uri}/api.asp?cmd=#{action}&#{options_string}"
          url = URI.parse(url_string)
          # request = Net::HTTP::Get.new(url.path, {"Content-Type"=>"text/xml"})
          request = Net::HTTP::Get.new(url_string, {"Content-Type"=>"text/xml"})
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = @uri.start_with? 'https'
          response = http.start {|http| http.request(request) }
          response.body
        end
      end
    end
  end
end
