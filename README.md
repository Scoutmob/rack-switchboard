# Rack::Switchboard

Rack::Switchboard is a Rack middleware which loads rewrite rules from an external store so new rules can be added or removed without having to deploy code or restart the server.  Switchboard is developed to support different stores for the rewrite rules.  Currently, an memory store and a Redis store are provided.

This gem also provides a small Rack app which provides an admin to manage rules.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-switchboard'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-switchboard

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
