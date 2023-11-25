require_relative "lib/linkedin_sign_in/version"

Gem::Specification.new do |spec|
  spec.name        = "linkedin_sign_in"
  spec.version     = LinkedinSignIn::VERSION
  spec.authors     = ["Bogusław Tolarz"]
  spec.email       = ["btolarz@gmail.com"]
  spec.homepage    = "https://github.com/btolarz/linkedin_sign_in"
  spec.summary     = "LinkedIn Sign In for Rails"
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 5.2.0"
  spec.add_dependency 'jwt', '>= 1.5.6'

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "webmock"
end
