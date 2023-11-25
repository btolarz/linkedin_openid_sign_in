require 'rails/engine'
require 'linkedin_sign_in' unless defined?(LinkedinSignIn)

module LinkedinSignIn
  class Engine < ::Rails::Engine
    isolate_namespace LinkedinSignIn

    config.linkedin_sign_in = ActiveSupport::OrderedOptions.new.update options: LinkedinSignIn.options

    initializer 'linkedin_sign_in.config' do |app|
      config.after_initialize do
        LinkedinSignIn.client_id     = config.linkedin_sign_in.client_id || app.credentials.dig(:linkedin_sign_in, :client_id)
        LinkedinSignIn.client_secret = config.linkedin_sign_in.client_secret || app.credentials.dig(:linkedin_sign_in, :client_secret)

        LinkedinSignIn.options = {
          scope: 'openid email'
        }
      end
    end

    initializer 'linkedin_sign_in.mount' do |app|
      app.routes.prepend do
        mount LinkedinSignIn::Engine, at: app.config.linkedin_sign_in.root || 'linkedin_sign_in'
      end
    end

  end
end
