# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zendesk/version"

Gem::Specification.new do |s|
  s.name        = "zendesk"
  s.version     = Zendesk::VERSION
  s.authors     = ["Juris Galang"]
  s.email       = ["jurisgalang@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby bindings for the Zendesk API}
  s.description = %q{Ruby bindings for the Zendesk API}

  s.rubyforge_project = "zendesk"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  
  s.add_runtime_dependency "named-parameters"
  s.add_runtime_dependency "builder"
  s.add_runtime_dependency "crack"
  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "activesupport"
end
