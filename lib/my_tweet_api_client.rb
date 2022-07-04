class MyTweetApiClient

  # OAuthのログインURLを生成する
  def auth_url
    uri = URI(TWEET_APP_AUTH_URL + AUTHORIZE_PATH)
    uri.query = {
      client_id: CLIENT_ID,
      response_type: RESPONSE_TYPE,
      redirect_uri: REDIRECT_URL
    }.to_param
    URI.decode_www_form_component(uri.to_s)
  end

  # アクセストークンの取得
  def get_token(code)
    uri = URI(TWEET_APP_AUTH_URL + TOKEN_PATH)

    params = {
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      code: code,
      response_type: RESPONSE_TYPE,
      redirect_uri: REDIRECT_URL,
      grant_type: "authorization_code"
    }
    response = Net::HTTP.post_form(uri, params)
    json = JSON.parse(response.body)
    json["access_token"]
  end

  # MyTweetAppに投稿する
  def post_tweet(text, url, access_token)
    uri = URI(TWEET_APP_AUTH_URL + TWEET_PATH)
    params = {
      text: text,
      url: url
    }
    headers = { "Content-Type" => "application/json", "Authorization" => "Bearer #{access_token}" }
    response = Net::HTTP.post(uri, params.to_json, headers)
    response.code == 201
  end

  private

  TWEET_APP_AUTH_URL = ENV.fetch('TWEET_APP_AUTH_URL')
  CLIENT_ID = ENV.fetch('TWEET_APP_AUTH_CLIENT_ID')
  CLIENT_SECRET = ENV.fetch('TWEET_APP_AUTH_CLIENT_SECRET')

  AUTHORIZE_PATH = '/oauth/authorize'
  TOKEN_PATH = '/oauth/token'
  TWEET_PATH = '/api/tweets'

  RESPONSE_TYPE = "code"
  REDIRECT_URL = "http://localhost:3000/oauth/callback"

end
