module Fogbugz
  
  class RequestError < StandardError; end
  class InitializationError < StandardError; end

  class Interface
    attr_reader :uri
    attr_accessor :token, :email, :password
    
    def initialize(uri, options = {})
      @uri = uri.to_s.chomp('/')
      default = {
        :root => '/',
        :endpoint => 'api.asp'
      }
      @root, @endpoint, @token, @email, @password  = default.merge(options).
        values_at(:root, :endpoint, :token, :email, :password)
      @uri = File.join(@uri, @root.gsub('/', ''), @endpoint.gsub('/', ''))
    end

    def command(name, params = {})
      params = set_token(params)
      params.merge!(:cmd => name.to_s)
      xml_adapter.parse(http_adapter.get(params))
    end

    def logon(params = {})
      @token = command(:logon, params)["token"]
    end

    alias :authenticate :logon
    
    private
    def set_token(params)
      params.merge! :token => @token if @token
      return params
    end
    
    def http_adapter
      Fogbugz.http_adapter(@uri)
    end

    def xml_adapter
      Fogbugz.xml_adapter
    end
  end
end
