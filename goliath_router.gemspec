# -*- encoding: utf-8 -*-
require File.expand_path('../lib/goliath_router/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Julien Ammous"]
  gem.email         = ["schmurfy@gmail.com"]
  gem.description   = %q{Router extension for goliath}
  gem.summary       = %q{Add Routing to goliath core}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "goliath_router"
  gem.require_paths = ["lib"]
  gem.version       = GoliathRouter::VERSION
  
  
  gem.add_dependency 'goliath', '0.9.4'
  gem.add_dependency 'http_router'
  
  gem.add_development_dependency 'rake', '>=0.8.7'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'rspec', '>2.0'
  gem.add_development_dependency 'em-http-request', '>=1.0.0'
  gem.add_development_dependency 'yajl-ruby'
  gem.add_development_dependency 'tilt'
  
end
