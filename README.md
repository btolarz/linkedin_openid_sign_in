# LinkedIn Sign-In for Rails
This gem enables you to add LinkedIn sign-in functionality to your Rails app. With it, users can sign up for and sign in to your service using their LinkedIn accounts. This gem is highly inspired by [google_sign_in](https://github.com/basecamp/google_sign_in), and its configuration and usage are very similar.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'linkedin_openid_sign_in'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install linkedin_openid_sign_in
```

## Usage

### Configuration

Setup you LinkedIn app and get OAuth credentials  
1. Go to [LinkedIn Developer Console](https://www.linkedin.com/developers/apps)
2. Click "Create App" button on the top right corner
3. Enter app name
4. You need LinkedIn page, you can add existing page or create new one here. Page admin will have to accept your app.
5. Add logo
6. Click "Create App" button
7. ⚠️IMPORTANT: Page admin will have to accept your app. You can check status on the top of the page.
8. Click "Auth" tab
9. Add "Authorized redirect URLs" (e.g. `http://localhost:3000/linkedin_openid_sign_in/callbacks#show`)

   This gem use `/linkedin_openid_sign_in/callbacks` path as callback path and then redirect to provided `redirect_url` option

10. Click "Save" button
11. Copy "Client ID" and "Client Secret" and add to your Rails app credentials
ex.: `EDITOR='code --wait' rails credentials:edit`

```yaml
linkedin_sign_in:
  client_id: [Your client ID here]
  client_secret: [Your client secret here]
```

## Usage

### Link to login

```
<%= link_to 'Linkedin login', linkedin_openid_sign_in.sign_in_path(redirect_url: create_login_url) %>
```

### Callback redirect
You can adjust `redirect_url` to your needs. It will be called after successful login.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ...
  get 'login/create', to: 'logins#create', as: :create_login
end
```

```ruby
# app/controllers/logins_controller.rb
class LoginsController < ApplicationController
  def create
    if user = authenticate_with_google
      cookies.signed[:user_id] = user.id
      redirect_to user
    else
      redirect_to new_session_url, alert: 'authentication_failed'
    end
  end

  private
    def authenticate_with_google
      if sub = flash[:linkedin_sign_in]['sub']
        User.find_by linkedin_id: sub
      elsif flash[:linkedin_sign_in]
        nil
      end
    end
end
```

### Success response
Response is stored in `flash[:linkedin_sign_in]` and contains following keys:
```ruby
    {
        'iss': 'https://www.linkedin.com',
        'aud': 'aud',
        'iat': 1700919389,
        'exp': 1700919389,
        'sub': 'sub',
        'email': 'btolarz@gmail.com',
        'email_verified': true,
        'locale': 'en_US'
    }
```

Check details on https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2?context=linkedin%2Fconsumer%2Fcontext#id-token-payload

### Failure response

1. InvalidState - raised when returned state is different than stored state
2. Error from linkedIn - returned in `flash[:linkedin_sign_in][:error]` and `flash[:linkedin_sign_in][:error_description]` ex.: `user_cancelled_login`

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
