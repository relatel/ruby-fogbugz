require 'test_helper'
require 'ruby_fogbugz/adapters/xml/cracker'

class Cracker < FogTest
  test 'should parse XML and get rid of the response namespace' do
    xml = <<-xml
      <?xml version="1.0" encoding="UTF-8"?>
      <response>
        <version>2</version>
      </response>
    xml

    assert_equal({ 'version' => '2' }, Fogbugz::Adapter::XML::Cracker.parse(xml))
  end

  # Sometimes Fogbugz returns responses like this
  test 'should return nil when the response is not valid' do
    xml = <<-xml
      <html><head><title>Object moved</title></head><body>
      <h2>Object moved to <a href="http://example.fogbugz.com:84/internalError.asp?aspxerrorpath=/api.asp">here</a>.</h2>
      </body></html>
    xml

    assert_equal(nil, Fogbugz::Adapter::XML::Cracker.parse(xml))
  end
end
