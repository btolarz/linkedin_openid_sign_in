require 'test_helper'

class LinkedinOpenidSignIn::SignInControllerTest < ActionDispatch::IntegrationTest
  setup do
    @redirect_url = 'http://www.example.com/login'
    LinkedinOpenidSignIn.client_id = 'client_id'
  end

  test "redirecting to Google for authorization" do
    get linkedin_openid_sign_in.sign_in_url(redirect_url: @redirect_url)

    assert_response :redirect

    query = URI(redirect_to_url).query
    params = Rack::Utils.parse_query(query).symbolize_keys

    assert_equal "code", params[:response_type]
    assert_equal LinkedinOpenidSignIn.client_id, params[:client_id]
    assert_equal linkedin_openid_sign_in.callback_url, params[:redirect_uri]
    assert_equal params[:state], flash[:linkedin_sign_in][:state]
    assert_equal "openid email", params[:scope]
    assert_equal @redirect_url, flash[:linkedin_sign_in][:redirect_url]
  end
end