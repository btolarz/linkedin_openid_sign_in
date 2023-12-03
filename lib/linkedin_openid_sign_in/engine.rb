require 'rails/engine'
require 'linkedin_openid_sign_in' unless defined?(LinkedinOpenidSignIn)

module LinkedinOpenidSignIn
  class Engine < ::Rails::Engine
    isolate_namespace LinkedinOpenidSignIn

    config.linkedin_openid_sign_in = ActiveSupport::OrderedOptions.new.update options: LinkedinOpenidSignIn.options

    initializer 'linkedin_openid_sign_in.config' do |app|
      config.after_initialize do
        LinkedinOpenidSignIn.client_id     = config.linkedin_openid_sign_in.client_id || app.credentials.dig(:linkedin_sign_in, :client_id)
        LinkedinOpenidSignIn.client_secret = config.linkedin_openid_sign_in.client_secret || app.credentials.dig(:linkedin_sign_in, :client_secret)

        LinkedinOpenidSignIn.options = {
          scope: 'openid email'
        }
      end
    end

    initializer 'linkedin_openid_sign_in.mount' do |app|
      app.routes.prepend do
        mount LinkedinOpenidSignIn::Engine, at: app.config.linkedin_openid_sign_in.root || 'linkedin_openid_sign_in'
      end
    end

  end
end
