$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "anlek_bootstrap_helper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "anlek_bootstrap_helper"
  s.version     = AnlekBootstrapHelper::VERSION
  s.authors     = ["Andrew Kalek"]
  s.email       = ["andrew.kalek@anlek.com"]
  s.homepage    = "http://anlek.com"
  s.summary     = "A helper to generate Twitter Bootstrap code"
  s.description = "A gem that helps you write cleaner Twitter Bootstrap HTML code."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-shell"
  s.add_development_dependency "thor"
end
