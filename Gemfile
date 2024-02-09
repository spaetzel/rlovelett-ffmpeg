ruby '3.2.3'
source "https://rubygems.org"

gem "rubocop", ">= 1.15.0", require: false

gemspec

group :pronto do
  gem 'rubocop-performance', ">= 1.11.0", require: false
  gem 'rubocop-rake', '>= 0.5.1', require: false

  # Mainly for being run in GH Action
  gem 'faraday-retry', require: false
  gem "pronto", require: false
  gem "pronto-rubocop", require: false
  gem 'pronto-undercover', require: false
end

group :test do
  gem 'rugged'
  gem 'simplecov'
  gem 'simplecov-lcov'
end
