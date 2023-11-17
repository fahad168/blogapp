class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require 'googleauth'
  PASSWORD_DIGEST = SecureRandom.hex(10)
  def google_oauth2
    user = create_user(auth[:info][:email], auth[:provider], auth)

    if user.present?
      sign_out_all_scopes
      flash[:notice] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
    end
  end
  def google_onetap
    if g_csrf_token_valid?
      payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV['GOOGLE_CLIENT_ID'])
      user = create_user(payload["email"], nil, payload)
      sign_in(user)
      redirect_to(root_path)
    else
      redirect_to(user_session_path, notice: 'sign in failed')
    end
  end

  def facebook; end

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def create_user(email, _provider_id, response)
    resource = User.find_by(email: email)
    if resource
      resource.update(provider: 'Google')
      resource
    else
      # name = response[:info][:name].present? ? response[:info][:name] : ""
      @user = User.new(email: email, username: response['name'], password: PASSWORD_DIGEST, password_confirmation: PASSWORD_DIGEST, provider: 'Google')
      @user.save(validate: false)
      @user
    end
  end

  def g_csrf_token_valid?
    cookies['g_csrf_token'] == params['g_csrf_token']
  end
end
