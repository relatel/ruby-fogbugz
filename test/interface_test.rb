require 'test_helper.rb'

class FogTest
  CREDENTIALS = {
    email:    'test@test.com',
    password: 'seekrit',
    uri:      'http://fogbugz.test.com'
  }

  VALID_AUTH = '<?xml version="1.0" encoding="UTF-8"?><response><token><![CDATA[abcdefabcdefabcdefabcdefabcdef]]></token></response>'
  INVALID_AUTH = '<?xml version="1.0" encoding="UTF-8"?><response><error code="1"><![CDATA[Incorrect password or username]]></error></response>'
end

class BasicInterface < FogTest
  def setup
    @fogbugz = Fogbugz::Interface.new(CREDENTIALS)
  end

  test 'when instantiating options should be overwriting and be publicly available' do
    assert_equal CREDENTIALS, @fogbugz.options
  end
end

class InterfaceRequests < FogTest
  test 'authentication should send correct parameters' do
    fogbugz = Fogbugz::Interface.new(CREDENTIALS)
    fogbugz.http.expects(:request).with(:logon,
                                        params: {
                                          email: CREDENTIALS[:email],
                                          password: CREDENTIALS[:password]
                                        }).returns(VALID_AUTH)
    fogbugz.authenticate
  end

  test 'invalid authentication throws exception' do
    fogbugz = Fogbugz::Interface.new(CREDENTIALS)
    fogbugz.http.expects(:request).with(:logon,
                                        params: {
                                          email: CREDENTIALS[:email],
                                          password: CREDENTIALS[:password]
                                        }).returns(INVALID_AUTH)

    assert_raises Fogbugz::AuthenticationException do
      fogbugz.authenticate
    end
  end

  test 'invalid XML response throws exception' do
    fogbugz = Fogbugz::Interface.new(CREDENTIALS)
    fogbugz.http.expects(:request).with(:logon,
                                        params: {
                                          email: CREDENTIALS[:email],
                                          password: CREDENTIALS[:password]
                                        }).returns('<html></head>')

    assert_raises Fogbugz::AuthenticationException do
      fogbugz.authenticate
    end
  end

  test 'requesting with an action should send along token and correct parameters' do
    fogbugz = Fogbugz::Interface.new(CREDENTIALS)
    fogbugz.token = 'token'
    fogbugz.http.expects(:request).with(:search, params: { q: 'case', token: 'token' }).returns('omgxml')
    fogbugz.xml.expects(:parse).with('omgxml')
    fogbugz.command(:search, q: 'case')
  end

  test 'throws an exception if #command is requested with no token' do
    fogbugz = Fogbugz::Interface.new(CREDENTIALS)
    fogbugz.token = nil

    assert_raises Fogbugz::Interface::RequestError do
      fogbugz.command(:search, q: 'case')
    end
  end
end
