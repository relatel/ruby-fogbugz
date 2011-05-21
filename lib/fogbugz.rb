require_relative 'ruby-fogbugz/adapters/http/typhoeus'
require_relative 'ruby-fogbugz/adapters/xml/cracker'
require_relative 'ruby-fogbugz/interface'

module Fogbugz
  class << self
    attr_accessor :adapter
  end

  self.adapter = {
    :xml  => Adapter::XML::Cracker,
    :http => Adapter::HTTP::Typhoeuser
  }
end
