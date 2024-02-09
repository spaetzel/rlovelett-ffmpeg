ruby '3.2.2'
source "https://rubygems.org"

gem 'rubocop'

gemspec

group :pronto do
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false

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
