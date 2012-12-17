# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'ultimate/helpers/version'

Gem::Specification.new do |s|
  s.name        = 'ultimate-helpers'
  s.version     = Ultimate::Helpers::VERSION
  s.authors     = ['Dmitry KODer Karpunin']
  s.email       = ['koderfunk@gmail.com']
  s.homepage    = 'http://github.com/KODerFunk/ultimate-helpers'
  s.summary     = %q{Ultimate Helpers, Rails ActionView helpers ported to CoffeeScript}
  s.description = %q{Ultimate Helpers, Rails ActionView helpers ported to CoffeeScript}

  s.rubyforge_project = 'ultimate-helpers'

  s.add_development_dependency 'rails', '~> 3.2.8'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'coffee-rails', '~> 3.2.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

end
