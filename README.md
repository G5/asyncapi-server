# Asyncapi::Server

`Asyncapi::Server` is a Rails engine that allows asynchronous responses for API calls made by [Asyncapi::Client](https://github.com/G5/asyncapi-client).

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

If you use `protected_attributes`, in an initializer:

```ruby
Asyncapi::Server::Job.attr_accessible :status, :callback_url, :class_name, :params, :secret
```

## License

Copyright (c) 2014 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
