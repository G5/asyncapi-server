$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "asyncapi/server/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "asyncapi-server"
  s.version     = Asyncapi::Server::VERSION
  s.authors     = ["G5", "Marc Ignacio", "Ramon Tayag"]
  s.email       = ["lateam@getg5.com", "marcrendlignacio@gmail.com", "ramon.tayag@gmail.com"]
  s.homepage    = "https://github.com/G5/asyncapi-server"
  s.summary     = "Asynchronous API communication - Server"
  s.description = "Asynchronous API communication - Server"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "kaminari"
  s.add_dependency "api-pagination"
  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "active_model_serializers", "~> 0.9.0"
  s.add_dependency "typhoeus"
  s.add_dependency "sidekiq"
  s.add_dependency "responders", "~> 2.0"

  s.add_development_dependency "sqlite3", "~> 1.3.10"
  s.add_development_dependency "rspec-rails", "~> 3.1.0"
  s.add_development_dependency "rspec-its", "~> 1.1.0"
  s.add_development_dependency "pry", "~> 0.10.1"
  s.add_development_dependency "factory_girl_rails", "~> 4.4.0"
  s.add_development_dependency "database_cleaner", "~> 1.3.0"
  s.add_development_dependency "timecop"
end
