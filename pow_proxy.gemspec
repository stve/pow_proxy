# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pow_proxy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "pow_proxy"
  gem.version       = PowProxy::VERSION

  gem.authors       = ["Steve Agalloco"]
  gem.email         = ["steve.agalloco@gmail.com"]
  gem.description   = 'A simple rack-based proxy that allows you to run your node apps through Pow.'
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/spagalloco/pow_proxy"

  gem.add_dependency 'rack'
  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rdiscount', '~> 1.6'
  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'simplecov', '~> 0.5'
  gem.add_development_dependency 'yard', '~> 0.7'
  gem.add_development_dependency 'webmock', '~> 1.7'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
end
