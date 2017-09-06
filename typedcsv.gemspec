# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "typedcsv/version"

Gem::Specification.new do |spec|
  spec.name          = "typedcsv"
  spec.version       = Typedcsv::VERSION
  spec.authors       = ["Seamus Abshere"]
  spec.email         = ["seamus@abshere.net"]

  spec.summary       = %q{Thin wrapper around Ruby's stdlib CSV parser that adds typed csv support.}
  spec.homepage      = "https://github.com/faradayio/typedcsv-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
