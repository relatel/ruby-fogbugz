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
  end

end
