require 'test_helper'

class LinkedinSignIn::CallbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @redirect_url = 'http://www.example.com/login'
    LinkedinSignIn.client_id = 'client_id'
    LinkedinSignIn.client_secret = 'client_secret'

    @payload = {
      iss: 'https://www.linkedin.com',
      aud: 'aud',
      iat: 1700919389,
      exp: 1700919389,
      sub: 'sub',
      email: 'btolarz@gmail.com',
      email_verified: true,
      locale: 'en_US'
    }

    @rsa_private = OpenSSL::PKey::RSA.generate 2048
    @token = JWT.encode @payload, @rsa_private, 'RS256'

    stub_request(:post, "https://www.linkedin.com/oauth/v2/accessToken").
      with(
        body: {
          "client_id"=> LinkedinSignIn.client_id,
          "client_secret"=>LinkedinSignIn.client_secret,
          "code"=> @token,
          "grant_type"=>"authorization_code",
          "redirect_uri"=>"http://www.example.com/linkedin_sign_in/callback"},
        ).
      to_return(status: 200,
                body: { access_token: 'access_token', expires_in: 15, scope: 'email,openid', token_type: 'Bearer', id_token: @token }.to_json,
                headers: {})
  end

  test "redirecting to Google for authorization" do
    get linkedin_sign_in.sign_in_url(redirect_url: @redirect_url)
    get linkedin_sign_in.callback_url(code: @token, state:  flash[:linkedin_sign_in][:state])

    assert_response :redirect
    assert_redirected_to @redirect_url

    assert_equal @payload, flash[:linkedin_sign_in].symbolize_keys
  end
end