require 'hashie'

module Fogbugz
  class Command < Hashie::Clash
    attr_reader :uri, :method
    
    def initialize(uri, params={})
      super(params)
      @uri = uri
      @method = :get
    end

    [:get, :post].each do |m|
      define_method "#{m}!" do
        instance_variable_set :@method, m
      end
    end

    def execute
      xml_adapter.parse http_adapter.get(to_hash)
    end

    private
    def http_adapter
      Fogbugz.http_adapter(@uri)
    end

    def xml_adapter
      Fogbugz.xml_adapter
    end
  end

end
