require 'test_helper'

class LinkedinOpenidSignIn::CallbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @redirect_url = 'http://www.example.com/login'
    LinkedinOpenidSignIn.client_id = 'client_id'
    LinkedinOpenidSignIn.client_secret = 'client_secret'

    @payload = {
      iss: 'https://www.linkedin.com',
      aud: 'aud',
      iat: 1700919389,
      exp: 1700919389,
      sub: 'sub',
      email: 'btolarz@gmail.com',
      email_verified: true,
      locale: 'en_US',
      access_token: 'access_token'
    }

    @rsa_private = OpenSSL::PKey::RSA.generate 2048
    @token = JWT.encode @payload, @rsa_private, 'RS256'

    stub_request(:post, "https://www.linkedin.com/oauth/v2/accessToken").
      with(
        body: {
          "client_id"=> LinkedinOpenidSignIn.client_id,
          "client_secret"=>LinkedinOpenidSignIn.client_secret,
          "code"=> @token,
          "grant_type"=>"authorization_code",
          "redirect_uri"=>"http://www.example.com/linkedin_openid_sign_in/callback"},
        ).
      to_return(status: 200,
                body: { access_token: 'access_token', expires_in: 15, scope: 'email,openid', token_type: 'Bearer', id_token: @token }.to_json,
                headers: {})
  end

  test "redirecting from linkedin for authorization" do
    get linkedin_openid_sign_in.sign_in_url(redirect_url: @redirect_url)
    get linkedin_openid_sign_in.callback_url(code: @token, state:  flash[:linkedin_sign_in][:state])

    assert_response :redirect
    assert_redirected_to @redirect_url

    assert_equal @payload, flash[:linkedin_sign_in].symbolize_keys
  end

  test "redirecting from linkedin for authorization with invalid state" do
    get linkedin_openid_sign_in.sign_in_url(redirect_url: @redirect_url)

    assert_raises LinkedinOpenidSignIn::CallbacksController::InvalidState do
      get linkedin_openid_sign_in.callback_url(code: @token, state:  'invalid_state')
    end
  end

  test "redirecting from linkedin for authorization with error" do
    get linkedin_openid_sign_in.sign_in_url(redirect_url: @redirect_url)

    get linkedin_openid_sign_in.callback_url(code: @token, state:  flash[:linkedin_sign_in][:state], error: 'invalid_request', error_description: 'Invalid request')

    assert_response :redirect
    assert_redirected_to @redirect_url

    assert_equal 'invalid_request', flash[:linkedin_sign_in][:error]
    assert_equal 'Invalid request', flash[:linkedin_sign_in][:error_description]
  end


end