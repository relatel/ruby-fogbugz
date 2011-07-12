module Fogbugz
  class Command
    attr_reader :uri, :method
    
    def initialize(uri)
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
