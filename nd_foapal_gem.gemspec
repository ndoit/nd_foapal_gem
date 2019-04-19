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

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency "jquery-rails", "~> 4.3.3"
  s.add_dependency "jquery-ui-rails", "> 5.0.3"
  s.add_dependency "foundation-rails", "~> 6.5.3.0"
  s.add_dependency "sass-rails", "~> 5.0.0"
  s.add_dependency 'persistent_httparty', '~> 0.1.2'
  s.add_dependency 'dotenv'
  s.add_development_dependency "sqlite3", '~> 1.4.0'
  s.add_development_dependency 'rspec-rails', '~> 3.8.0'
  # s.add_development_dependency 'selenium-webdriver', '~> 2.53.4'
  # s.add_development_dependency 'chromedriver-helper', '~> 1.1.0'

  s.add_development_dependency 'shoulda-matchers', '~> 4.0.1'
end
