# ruby-fogbugz

Ruby-fogbugz is a very simple wrapper for the Fogbugz API. The Fogbugz API works by sending HTTP GET parameters to the API where `cmd` invokes a Fogbugz method, e.g. `cmd=listProjects` to get a list of all projects.

An example of a request sent to the Fogbugz API to list all projects:

    ?cmd=search&ixAssignedTo=2 # all cases associated to the user with ID of 2 in Fogbugz

In ruby-fogbugz that would be:

    fogbugz.command(:listProjects, :ixAssignedTo => 2)

That leaves `cmd` as the first argument to 'Fogbugz#command', the second argument is a `Hash` of additional GET arguments to specify the request further. You can see available `cmd`'s and arguments at the [Fogbugz API documentation][fad].

All Fogbugz API requests require a token. Thus `#authenticate` must be called on the instance before `#command`'s are sent.

    fogbugz = Fogbugz::Interface.new(:email => 'my@email.com', :password => 'seekrit', :uri => 'http://company.fogbugz.com')
    fogbugz.authenticate # token is not automatically attached to every future requests
    fogbugz.command(:listPeople)
