require 'test_helper'

class CommandTest < FogTest
  def setup
    @uri = 'http://fogbugz.example.com/api.asp'
  end

  test 'initializing with uri' do
    c = Fogbugz::Command.new(@uri)
    assert_equal @uri, c.uri
  end

  test 'default method' do
    c = Fogbugz::Command.new @uri
    assert_equal :get, c.method
  end
  
  test 'setting get method on command' do
    c = Fogbugz::Command.new @uri
    c.get!
    assert_equal :get, c.method
  end

  test 'setting post method on command' do
    c = Fogbugz::Command.new @uri
    c.post!
    assert_equal :post, c.method
  end
end  
