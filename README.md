[![Gem Version](https://img.shields.io/gem/v/ruby-fogbugz.svg)][gem]
[![Build Status](https://img.shields.io/travis/firmafon/ruby-fogbugz.svg)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/firmafon/ruby-fogbugz.svg)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/firmafon/ruby-fogbugz.svg)][codeclimate]
[![Test Coverage](https://img.shields.io/codeclimate/coverage/github/firmafon/ruby-fogbugz.svg)][coverage]

[gem]: https://rubygems.org/gems/ruby-fogbugz
[travis]: https://travis-ci.org/firmafon/ruby-fogbugz
[gemnasium]: https://gemnasium.com/firmafon/ruby-fogbugz
[codeclimate]: https://codeclimate.com/github/firmafon/ruby-fogbugz
[coverage]: https://codeclimate.com/github/firmafon/ruby-fogbugz/coverage

# ruby-fogbugz

A very simple wrapper for the Fogbugz API. It won't give you fancy classes for everything, it'll simply aid you in sending the API requests, parsing the returned XML finally retuning you a Hash.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-fogbugz'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-fogbugz

## Usage

The Fogbugz API works by sending HTTP GET parameters to the API where the GET parameter `cmd` invokes a Fogbugz method, e.g. `cmd=listProjects` to get a list of all projects, `cmd`s then accept further arguments, such as listing all cases assigned to a specific person:

    cmd=search&ixAssignedTo=2&cols=sTitle,sStatus # list all cases associated to the user with ID of 2 in Fogbugz

In `ruby-fogbugz` that request would be:

```ruby
fogbugz.command(:search, :ixAssignedTo => 2, :cols => "sTitle,sStatus")
```

Returns your parsed XML:

```ruby
{
  "description"=>"All open cases assigned to Simon Eskildsen",
  "cases" => {
    "case"=> [
      {"ixBug"=>"143", "sTitle"=>"Write ruby-fogbugz documentation",
      "sStatus"=>"active", "operations"=>"edit,assign,resolve,email,remind"},
      {"ixBug"=>"146", "sTitle"=>"Tame a unicorn", "sStatus"=>"active",
      "operations"=>"edit,assign,resolve,email,remind"},
      {"ixBug"=>"152", "sTitle"=>"Hug a walrus", "sStatus"=>"active",
      "operations"=>"edit,assign,resolve,email,remind"},
    ], "count"=>"3"
  }
}
```

As you see, `ruby-fogbugz` is without magic and leaves most to the user.

`cmd` is the first argument to `Fogbugz#command`, the second argument being a `Hash` of additional GET arguments to specify the request further. You can see available `cmd`'s and arguments at the [Fogbugz API documentation][fad].

All Fogbugz API requests require a token. Thus `#authenticate` must be called on the `ruby-fogbugz` instance before `#command`'s are sent:

```ruby
require 'fogbugz'

fogbugz = Fogbugz::Interface.new(:email => 'my@email.com', :password => 'seekrit', :uri => 'https://company.fogbugz.com') # remember to use https!
fogbugz.authenticate # token is now automatically attached to every future requests
p fogbugz.command(:listPeople)
```

`#authenticate` fetches a new token every time. To avoid the extra request,
obtain a token:

```ruby
require 'fogbugz'

fogbugz = Fogbugz::Interface.new(:email => 'my@email.com', :password => 'seekrit', :uri => 'https://company.fogbugz.com') # remember to use https!
fogbugz.authenticate # token is now automatically attached to every future requests

puts "Token: #{fogbugz.token}"
```

Run the script, and initialize with the returned token:

```ruby
fogbugz = Fogbugz::Interface.new(:token => "some token to use from now on", :uri => 'https://company.fogbugz.com') # remember to use https!
```

### Attachments

This library supports multipart file uploads to include attachments in your API request. A multipart request body is created (using the [multipart-post][mpp] gem) if `File1` is found in the command parameters. Files can be attached as follows:

```ruby
fogbugz.command(:new, sProject: "SomeProject", sArea: "someArea", sTitle: "Case title", File1: UploadIO.new(f, "text/plain", "someFile.rb"))
```

[fad]:http://fogbugz.stackexchange.com/fogbugz-xml-api
[mpp]:https://github.com/nicksieger/multipart-post

## License

`ruby-fogbugz` is released under the MIT license.
