# Asyncapi::Server

`Asyncapi::Server` is a Rails engine that allows asynchronous responses for API calls made by `Asyncapi::Client`.

# Installation

Add `asyncapi-server` into your Gemfile, `bundle install`, then run the following commands:

```bash
rails g asyncapi:server:config
rake asyncapi_server:install:migrations
rake db:migrate
```

Make sure you have `:host` in the `default_url_options` set up for your server. Example `config/initializers/default_url_options.rb`:

```ruby
Rails.application.routes.default_url_options ||= {}
Rails.application.routes.default_url_options[:host] = ENV["HOST"]
```

# Usage

In your controller where you want a `create` action:

```ruby
# some_controller.rb
class SomeController < ApplicationController
  async :create, CreateSomething
end
```

Create the `CreateSomething` runner class that will be called in the background:

```ruby
# create_something.rb
class CreateSomething
  def self.call(params)
    something = Something.new(params)

    # the last line in this method is sent back to Asyncapi::Client as the `message`
    if something.save
      something.to_json
    else
      something.errors.messages
    end
  end
end
```
