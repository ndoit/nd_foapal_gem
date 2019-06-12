$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nd_foapal_gem/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nd_foapal_gem"
  s.version     = NdFoapalGem::VERSION
  s.authors     = ["Teresa Meyer"]
  s.email       = ["tmeyer2@nd.edu"]
  s.homepage    = "https://bitbucket.org/nd-oit/nd-foapal-gem"
  s.summary     = "Lookup and Validation of FOAPALs"
  s.description = "Provides javascript controllers for FOAPAL lookup and validation"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 5.0"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "foundation-rails"
  s.add_dependency "sass-rails"
  s.add_dependency 'persistent_httparty'
  s.add_dependency 'dotenv'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'chromedriver-helper'

  s.add_development_dependency 'shoulda-matchers'
end
