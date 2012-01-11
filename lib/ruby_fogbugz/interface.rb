module Fogbugz
  class Interface
    class RequestError < StandardError; end
    class InitializationError < StandardError; end
    
    attr_accessor :options, :http, :xml, :token

    def initialize(options = {})
      @options = {}.merge(options)

      raise InitializationError, "Must supply URI (e.g. https://fogbugz.company.com)" unless options[:uri]
      @token = options[:token] if options[:token]
      @http = Fogbugz.adapter[:http].new(:uri => options[:uri])
      @xml = Fogbugz.adapter[:xml]
    end

    def authenticate
      response = @http.request :logon, { 
        :params => {
          :email    => @options[:email],
          :password => @options[:password]
        }
      }
      begin
        @token ||= @xml.parse(response)["token"]
        if @token.nil? || @token == ''
          throw Fogbugz::AuthenticationException.new(@xml.parse(response)["error"])
        end
      rescue REXML::ParseException => e
        # Probably an issue with the auth information
        # p response
        throw Fogbugz::AuthenticationException.new("Looks like there was an issue with authentication (to #{@options[:uri]} as #{@options[:email]}) - probably the host/url.")
      end
      @token
    end

    def command(action, parameters = {})
      raise RequestError, 'No token available, #authenticate first' unless @token
      parameters[:token] = @token

      response = @http.request action, { 
        :params => parameters.merge(options[:params] || {})
      }

      @xml.parse(response)
    end
  end
  
  class AuthenticationException < Exception
  end
end
