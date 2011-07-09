require 'test_helper.rb'

class InitializationTest < FogTest
  def setup
    @uri = 'http://fogbugz.example.com'
  end

  test 'initializing with uri' do
    f = Fogbugz::Interface.new(@uri)
    assert_match /^#{@uri}/, f.uri
  end

  test 'removing trailing path separator from uri' do
    f = Fogbugz::Interface.new("#{@uri}/")
    assert_match /^#{@uri}/, f.uri
  end

  test 'accepting optional root path with leading path separator' do
    f = Fogbugz::Interface.new(@uri, :root => '/fogbugz')
    assert_match /^#{@uri}\/fogbugz\//, f.uri
  end

  test 'accepting optional root path with trailing path separator' do
    f = Fogbugz::Interface.new(@uri, :root => 'fogbugz/')
    assert_match /^#{@uri}\/fogbugz\//, f.uri
  end

  test 'accepting optional root path no path separator' do
    f = Fogbugz::Interface.new(@uri, :root => 'fogbugz')
    assert_match /^#{@uri}\/fogbugz\//, f.uri
  end

  test 'accepting optional endpoint for api' do
    f = Fogbugz::Interface.new(@uri, :endpoint => 'api.php')
    assert_match /\/api\.php$/, f.uri
  end

  test 'acceptiong endpoint and root options' do
    f = Fogbugz::Interface.new(@uri, :root => 'fogbugz', :endpoint => 'api.php')
    assert_equal "#{@uri}/fogbugz/api.php", f.uri
  end

  test 'accepting auth token option' do
    f = Fogbugz::Interface.new(@uri, :token => 'test')
    assert_equal 'test', f.token
  end
end

class AuthenticationTest < FogTest
  def setup
    @uri = 'http://fogbugz.example.com'
    @fogbugz = Fogbugz::Interface.new(@uri)
    @credentials = { :email => 'test@example.com', :password => 'testpassword' }
    @token = 'testtoken'
    @fogbugz.expects(:command).with(:logon, @credentials).
      returns 'token' => @token
  end

  test 'logon with given credentials' do
    @fogbugz.logon @credentials
    assert_equal @token, @fogbugz.token
  end

  test 'authentication with given credentials' do
    @fogbugz.authenticate @credentials
    assert_equal @token, @fogbugz.token
  end
end

class CommandTest < FogTest
  def setup
    @uri = 'http://fogbugz.example.com'
    @token = 'token'
    @fogbugz = Fogbugz::Interface.new(@uri, :token => @token)
  end

  test 'sending correct parameters with command' do
    adapter = mock()
    adapter.expects(:get).
      with(:cmd => 'search', :token => @token, :q => 'case').
      returns("<?xml version=\"1.0\"?><response><cases/></response>")
    @fogbugz.stubs(:http_adapter).returns(adapter)
    assert_equal({'cases' => nil}, @fogbugz.command(:search, :q => 'case'))
  end
end
