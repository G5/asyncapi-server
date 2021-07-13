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

Setup [sidekiq-throttled](https://github.com/sensortower/sidekiq-throttled) by adding the following to the rails app sidekiq.rb initializer:

```ruby
require "sidekiq/throttled"
Sidekiq::Throttled.setup!
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

Use the throttle option to allow limited conccurency given a value that can be fetched from job.params

```ruby
# Given a job: #<Asyncapi::Server::Job id: 1, status: nil, callback_url: "callback_url", class_name: "CreateSomething", params: {"storage_facility"=>{"external_id"=>"storage-facility-external-id"}, secret: "sekret">,
# a user can set concurrency for jobs having an external_id of "storage-facility-external-id"

# some_controller.rb
class SomeController < ApplicationController
  async :create, CreateSomething, { keys: ["storage_facility", "external_id"], concurrency: 1 }
end
```

If you use `protected_attributes`, in an initializer:

```ruby
Asyncapi::Server::Job.attr_accessible :status, :callback_url, :class_name, :params, :secret
```

## Usage without Asyncapi::Client

If you want to use this without asyncapi client, you need to prepare two things: the endpoint that asyncapi-server will reply to.

Create the job by POSTing the following to CreateSomething above:

```json
{
  "job": {
    "callback_url": "https://myclient.com/jobs_callback",
    "params": {
      "name": "Something's name",
      "approved": true
    },
    "secret": "A secret unique to this job, so that you know what job the server is referring to"
  }
}
```

When the server is done processing, it will post something to your client. Your endpoint must accept the following json as the body:

```
{
  "job": {
    "status": "success",
    "message": "The output of the Runner class (i.e. `CreateSomething`)",
    "secret": "The secret you had sent earlier (this is how you can be sure it's not someone else updating your endpoint)",
  }
}
```

### RSpec

If you want to create an integration spec for you Asyncapi server endpoint, make sure you require the helper:

```ruby
require "asyncapi/server/rspec"
```

When you make a request, instead of `post`, use `asyncapi_post`. Ex:

```ruby
asyncapi_post("/api/v1/long_running_job", params: { name: "Compute" })
```

This helper calls `post` underneath but builds the request in a way that Asyncapi server understands.

## Development

- Run `rake db:migrate && rake db:migrate RAILS_ENV=test`
- Make changes
- `rspec`

## License

Copyright (c) 2016 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
