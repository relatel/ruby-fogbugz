RSpec.describe 'Cracker' do
  context 'valid response xml' do
    let(:xml) { %q(<?xml version="1.0" encoding="UTF-8"?>
                   <response>
                     <version>2</version>
                   </response>) }

    it 'parses the response' do
      expect(parse_xml(xml)).to eq({ 'version' => '2' })
    end
  end

  context 'invalid response xml' do
    let(:xml) { %q(<html><head><title>Object moved</title></head><body>
                   <h2>Object moved to <a href="http://example.fogbugz.com:84/internalError.asp?aspxerrorpath=/api.asp">here</a>.</h2>
                   </body></html>) }

    it 'returns nil' do
      expect(parse_xml(xml)).to be_nil
    end
  end

  def parse_xml(xml)
    Fogbugz::Adapter::XML::Cracker.parse(xml)
  end
end
