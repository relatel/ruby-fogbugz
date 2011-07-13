require 'test_helper'
require 'ruby_fogbugz/adapters/http/typhoeus'

class TyphoeuserTest < FogTest
  def setup
    @uri = 'http://fogbugz.example.com/api.asp'
    @adapter = Fogbugz::Adapter::HTTP::Typhoeuser.new(@uri)
  end
  
  test 'get request' do
    response = stub(:success? => true, :body => 'test')
    Typhoeus::Request.expects(:get).with(@uri, :params => {:q => 'test'}).
      returns(response)
    assert_equal 'test', @adapter.get(:q => 'test')
  end

  test 'post request' do
    response = stub(:success? => true, :body => 'test')
    Typhoeus::Request.expects(:post).with(@uri, :params => {:q => 'test'}).
      returns(response)
    assert_equal 'test', @adapter.post(:q => 'test')
  end

  test 'request timed out' do
    response = stub(:success? => false, :body => 'error', :timed_out? => true)
    @adapter.stubs(:request).returns(response)
    assert_raises Fogbugz::RequestError, 'Request timed out' do
      @adapter.get(:q => 'test')
    end
  end

  test 'network error' do
    response = stub(:success? => false, :code => 0, :timed_out? => false,
                    :curl_error_message => 'bad')
    @adapter.stubs(:request).returns(response)
    assert_raises Fogbugz::RequestError, 'bad' do
      @adapter.get(:q => 'test')
    end
  end

  test 'server error' do
    response = stub(:success? => false, :code => 500, :timed_out? => false)
    @adapter.stubs(:request).returns(response)
    assert_raises Fogbugz::RequestError, "Request failed: 500" do
      @adapter.get :q => 'test'
    end             
  end
end
