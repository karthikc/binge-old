$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gulp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gulp"
  s.version     = Gulp::VERSION
  s.authors     = ["Karthik C"]
  s.email       = ["karthik.cs@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "A rails engine that helps users upload CSV data into excel with wonderful error reporting"
  s.description = "TODO: Description of Gulp."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency "jquery-rails", "~> 3.1.0"
  s.add_dependency "jquery-ui-rails", "~> 4.1.1"
  s.add_dependency "carrierwave", "~> 0.9.0"

  s.add_development_dependency "sqlite3"
end