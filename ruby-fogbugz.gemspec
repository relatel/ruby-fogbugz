# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'ruby_fogbugz/version'

Gem::Specification.new do |s|
  s.name        = 'ruby-fogbugz'
  s.version     = Fogbugz::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Simon Hørup Eskildsen', 'Jared Szechy']
  s.email       = ['sirup@sirupsen.com', 'jared.szechy@gmail.com']
  s.homepage    = 'https://github.com/firmafon/ruby-fogbugz'
  s.summary     = 'Ruby wrapper for the Fogbugz API'
  s.description = 'A simple Ruby wrapper for the Fogbugz XML API'
  s.license     = 'MIT'

  s.rubyforge_project = 'ruby-fogbugz'

  s.add_dependency 'crack', '~> 0.4'
  s.add_dependency 'multipart-post', '~> 2.0'

  s.add_development_dependency 'rake', '< 11.0'
  s.add_development_dependency 'webmock', '~> 1.21'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
