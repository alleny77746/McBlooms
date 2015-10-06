$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "anlek_layout_helper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "anlek_layout_helper"
  s.version       = AnlekLayoutHelper::VERSION
  s.authors       = ["Andrew Kalek"]
  s.email         = ["andrew.kalek@anlek.com"]
  s.summary       = %q{Simple set of helpers to aid in layout work.}
  s.description   = s.summary
  s.homepage      = "http://anlek.com"
  s.license       = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-shell"
  s.add_development_dependency "thor"
end
