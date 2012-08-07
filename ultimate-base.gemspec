# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ultimate-base/version"

Gem::Specification.new do |s|
  s.name        = "ultimate-base"
  s.version     = Ultimate::Base::VERSION
  s.authors     = ["Dmitry KODer Karpunin"]
  s.email       = ["koderfunk@gmail.com"]
  s.homepage    = "http://github.com/KODer/ultimate-base"
  s.summary     = %q{Ultimate UI core, base helpers and improves for Ruby on Rails Front-end}
  s.description = %q{Ultimate UI core, base helpers and improves for Ruby on Rails Front-end}

  s.rubyforge_project = "ultimate-base"

  #s.add_dependency "rails", "~> 3.1"
  #s.add_dependency "coffee-script", "~> 2.1"
  #s.add_dependency "sass", "~> 3.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
