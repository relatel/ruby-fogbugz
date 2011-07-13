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

  test 'initializing with parameters' do
    c = Fogbugz::Command.new @uri, :test => 'test'
    assert_equal 'test', c[:test]
  end

  test 'adding parameter values' do
    c = Fogbugz::Command.new @uri
    c.test1 'test'
    c.testTwo 'test2'
    assert_equal 'test', c[:test1]
    assert_equal 'test2', c[:testTwo]
  end

  test 'parameter chaining' do
    c = Fogbugz::Command.new @uri
    c.test('1').test2('2')
    assert_equal '1', c[:test]
    assert_equal '2', c[:test2]
  end

  test 'executing command via default get' do
    adapter = mock
    adapter.expects(:get).
      with(:test => 'test').
      returns("<?xml version=\"1.0\"?><response><test>test resp</test></response>")
    c = Fogbugz::Command.new @uri, :test => 'test'
    c.stubs(:http_adapter).returns(adapter)
    assert_equal({'test' => 'test resp'}, c.execute)
  end

  test 'executing command via explicit get' do
    adapter = mock
    adapter.expects(:get).
      with(:test => 'test').
      returns("<?xml version=\"1.0\"?><response><test>test resp</test></response>")
    c = Fogbugz::Command.new @uri, :test => 'test'
    c.get!
    c.stubs(:http_adapter).returns(adapter)
    assert_equal({"test" => 'test resp'}, c.execute)
  end

  test 'executing command via explicit post' do
    adapter = mock
    adapter.expects(:post).
      with(:test => 'test').
      returns("<?xml version=\"1.0\"?><response><test>test resp</test></response>")
    c = Fogbugz::Command.new @uri, :test => 'test'
    c.post!
    c.stubs(:http_adapter).returns(adapter)
    assert_equal({"test" => 'test resp'}, c.execute)
  end
end  
