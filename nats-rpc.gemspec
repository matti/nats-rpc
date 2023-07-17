
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nats/rpc/version"

Gem::Specification.new do |spec|
  spec.name          = "nats-rpc"
  spec.version       = NATS::RPC::VERSION
  spec.authors       = ["Matti Paksula"]
  spec.email         = ["matti.paksula@iki.fi"]

  spec.summary       = "RPC implemented on top of NATS"
  spec.description   = "RPC implemented on top of NATS"
  spec.homepage      = "https://github.com/matti/nats-rpc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nats-pure"
  spec.add_dependency "binding_of_caller"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
