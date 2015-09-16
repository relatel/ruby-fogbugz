RSpec.describe 'Interface' do
  let(:credentials) { { email: 'test@example.com', password: 'seekrit', uri: 'https://fogbugz.example.com' } }

  context 'initialization' do
    it 'options are publicly available' do
      fogbugz = Fogbugz::Interface.new(credentials)
      expect(fogbugz.options).to eq(credentials)
    end

    it 'raises exception without URI' do
      expect { Fogbugz::Interface.new }.to raise_error(Fogbugz::Interface::InitializationError)
    end
  end

  context 'when credentials are valid' do
    let(:fogbugz) { Fogbugz::Interface.new(credentials) }

    it '#authenticate returns a token' do
      token = fogbugz.authenticate
      expect(token).not_to be_nil
    end

    it '#command returns result' do
      fogbugz.token = 'abcdefabcdefabcdef'
      fogbugz.command(:search, q: '1')
    end
  end

  context 'when credentials are invalid' do
    let(:credentials) { super().merge(password: 'invalid') }
    let(:fogbugz) { Fogbugz::Interface.new(credentials) }

    it '#authenticate raises an exception' do
      expect { fogbugz.authenticate }.to raise_error(Fogbugz::AuthenticationException, 'Incorrect password or username')
    end

    it '#command raises an exception' do
      fogbugz.token = nil
      expect { fogbugz.command(:search, q: 'case') }.to raise_error(Fogbugz::Interface::RequestError)
    end
  end

  context 'when server does not reply as expected' do
    let(:credentials) { super().merge(uri: 'https://notfogbugz.example.com') }
    let(:fogbugz) { Fogbugz::Interface.new(credentials) }

    it '#authenticate raises an exception' do
      expect { fogbugz.authenticate }.to raise_error(Fogbugz::AuthenticationException)
    end
  end
end
