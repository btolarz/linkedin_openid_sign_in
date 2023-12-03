module LinkedinOpenidSignIn
  mattr_accessor :client_id
  mattr_accessor :client_secret
  mattr_accessor :options, default: {}
end

require "linkedin_openid_sign_in/version"
require 'linkedin_openid_sign_in/engine' if defined?(Rails) && !defined?(LinkedinOpenidSignIn::Engine)