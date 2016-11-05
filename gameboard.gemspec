# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gameboard/version'

Gem::Specification.new do |spec|
  spec.name          = "gameboard"
  spec.version       = Gameboard::VERSION
  spec.authors       = ["Sampson Crowley"]
  spec.email         = ["sampsonsprojects@gmail.com"]

  spec.summary       = %q{A coordinate grid based gameboard}
  spec.description   = %q{A clean functional gameboard for CLI games in ruby, that will return and place pieces based on a coordinate system}
  spec.homepage      = "https://github.com/SampsonCrowley/Board"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org/"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rspec-nc", "~> 0.3"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-remote", "~> 0.1.8"
  spec.add_development_dependency "pry-nav", "~> 0.2.4"
  spec.add_development_dependency "bump"
end
