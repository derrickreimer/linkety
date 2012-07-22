# -*- encoding: utf-8 -*-
require File.expand_path('../lib/linkety/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Derrick Reimer"]
  gem.email         = ["derrickreimer@gmail.com"]
  gem.description   = %q{A collection of handy link helpers for Rails views}
  gem.summary       = %q{Linkety is a collection of handy link helpers for Rails views.}
  gem.homepage      = "https://github.com/djreimer/linkety"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "linkety"
  gem.require_paths = ["lib"]
  gem.version       = Linkety::VERSION
end
