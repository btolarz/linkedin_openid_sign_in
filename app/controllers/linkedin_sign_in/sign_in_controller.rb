module LinkedinSignIn
  class SignInController < ActionController::Base
    def show
      client_id = LinkedinSignIn.client_id
      scope = LinkedinSignIn.options[:scope]

      linkedin_url = "https://www.linkedin.com/oauth/v2/authorization?response_type=code"+
        "&client_id=#{client_id}" +
        "&redirect_uri=#{callback_url}" +
        "&state=#{state}" +
        "&scope=#{scope}"

      redirect_to linkedin_url, allow_other_host: true, flash: {
                                                                  linkedin_sign_in: {
                                                                    state: state,
                                                                    redirect_url: params[:redirect_url]
                                                                  }
                                                                }
    end

    private

    def state
      @state ||= SecureRandom.urlsafe_base64(24)
    end
  end
end
