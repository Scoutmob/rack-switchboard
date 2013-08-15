# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/switchboard/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-switchboard"
  spec.version       = Rack::Switchboard::VERSION
  spec.authors       = ["Calvin Yu"]
  spec.email         = ["calvin@scoutmob.com"]
  spec.description   = %q{rack-switchboard is a Rack middleware for managing redirects. Instead of coding your redirects in a HTTP config file or Rack config block, redirect rules are loaded from a store}
  spec.summary       = %q{Managed redirection through rack}
  spec.homepage      = "http://github.com/cyu/rack-switchboard"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject {|f| f =~ /^(examples|.gitignore)/}
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_dependency "rack-rewrite"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
