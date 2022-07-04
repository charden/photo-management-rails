class OauthController < ApplicationController
  include OauthHelper

  def new
    redirect_to auth_url, allow_other_host: true
  end

  def callback
    access_token = get_token(params[:code])
    save_access_token_to_session(access_token) if access_token
    redirect_to root_path
  end

  def oauth_params
    params.permit(:code)
  end

end
