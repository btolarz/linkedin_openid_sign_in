module LinkedinSignIn
  mattr_accessor :client_id
  mattr_accessor :client_secret
  mattr_accessor :options, default: {}
end

require "linkedin_sign_in/version"
require 'linkedin_sign_in/engine' if defined?(Rails) && !defined?(LinkedinSignIn::Engine)