# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "ffmpeg/version"

Gem::Specification.new do |s|
  s.name        = "rlovelett-ffmpeg"
  s.version     = FFMPEG::VERSION
  s.authors     = ["David Backeus", "Ryan Lovelett"]
  s.email       = ["david@streamio.com", "ryan@lovelett.me"]
  s.homepage    = "http://github.com/RLovelett/rlovelett-ffmpeg"

  s.summary     = "Wraps ffmpeg to read metadata and transcodes videos."

  s.add_dependency('multi_json', '~> 1.15.0')
  s.add_dependency('posix-spawn', '~> 0.3.15')

  # rubocop:disable Gemspec/DevelopmentDependencies
  s.add_development_dependency("rspec", "~> 3.12.0")
  s.add_development_dependency("rake", ">= 13.0.6")
  # rubocop:enable Gemspec/DevelopmentDependencies

  s.files        = Dir.glob("lib/**/*") + %w(README.md LICENSE CHANGELOG)
end
