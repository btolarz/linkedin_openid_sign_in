module LinkedinSignIn
  class CallbacksController < ActionController::Base
    InvalidState = Class.new(StandardError)

    def show
      flash_data = flash[:linkedin_sign_in].symbolize_keys

      raise InvalidState.new("Invalid state") if params[:state].blank? || params[:state] != flash_data[:state]

      json = JSON.parse(token)
      data = decode_token(json['id_token'])

      redirect_to flash_data[:redirect_url], flash: { linkedin_sign_in: data }
    end

    private

    def state
      @state ||= session[:linkedin_sign_in_state]
    end

    def redirect_url
      @redirect_url ||= session[:linkedin_sign_in_redirect_url]
    end

    def token
      return @token if defined? @token

      url = URI("https://www.linkedin.com/oauth/v2/accessToken")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.body = "code=#{params[:code]}" +
        "&client_id=#{LinkedinSignIn.client_id}" +
        "&client_secret=#{LinkedinSignIn.client_secret}" +
        "&redirect_uri=#{callback_url}" +
        "&grant_type=authorization_code"

      response = https.request(request)
      @token = response.body
    end

    def decode_token(token)
      JWT.decode(token, nil, false, { algorithm: 'RS256' })[0]
    end
  end
end
