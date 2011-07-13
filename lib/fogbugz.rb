require 'ruby_fogbugz/adapters/http/typhoeus'
require 'ruby_fogbugz/adapters/xml/cracker'
require 'ruby_fogbugz/interface'
require 'ruby_fogbugz/command'

module Fogbugz
  class << self
    attr_accessor :adapter

    def http_adapter(uri)
      adapter[:http].new(uri)
    end

    def xml_adapter
      adapter[:xml]
    end
  end

  self.adapter = {
    :xml  => Adapter::XML::Cracker,
    :http => Adapter::HTTP::Typhoeuser
  }
end
