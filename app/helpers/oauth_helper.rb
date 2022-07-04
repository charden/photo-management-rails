require "net/http"

module OauthHelper
  def get_token(code)
    MyTweetApiClient.new.get_token(code)
  end

  def auth_url
    MyTweetApiClient.new.auth_url
  end

  def save_access_token_to_session(access_token)
    session[:access_token] = access_token
  end

  def access_token?
    !session[:access_token].nil?
  end
end
