# Tugg Api

> Interact with the Tugg API (www.tugg.com/api) via Ruby's EventMachine

## Installation

Add this line to your application's Gemfile:

    gem 'tugg_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tugg_api

## Usage

```ruby
client = TuggApi::Client.new(API_KEY)
client.get(api_type: 'titles', id: 1451)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
