require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
WebMock.disable_net_connect!(allow: 'codeclimate.com')

require 'fogbugz'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.disable_monkey_patching!

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  # config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.before(:each) do
    stub_request(:post, 'https://fogbugz.example.com/api.asp')
      .with(body: { cmd: 'logon', email: 'test@example.com', password: 'seekrit' })
      .to_return(body: '<?xml version="1.0" encoding="UTF-8"?><response><token><![CDATA[abcdefabcdefabcdefabcdefabcdef]]></token></response>')

    stub_request(:post, 'https://fogbugz.example.com/api.asp')
      .with(body: { cmd: 'logon', email: 'test@example.com', password: 'invalid' })
      .to_return(body: '<?xml version="1.0" encoding="UTF-8"?><response><error code="1"><![CDATA[Incorrect password or username]]></error></response>')

    stub_request(:post, 'https://fogbugz.example.com/api.asp')
      .with(body: { cmd: 'search', q: '1', token: 'abcdefabcdefabcdef' })
      .to_return(body: '<?xml version="1.0" encoding="UTF-8"?><response><cases count="1"><case ixBug="1" operations="edit,reopen,email,remind"></case></cases></response>')

    stub_request(:post, 'https://notfogbugz.example.com/api.asp')
      .with(body: { cmd: 'logon', email: 'test@example.com', password: 'seekrit' })
      .to_return(body: '<html></head></html>')
  end
end
