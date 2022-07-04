require "test_helper"
require 'webmock/minitest'

class PhotosTest < ActionDispatch::IntegrationTest
  setup do
    post "/login", params: { name: "test", password: "password" }
    @photo = photos(:one)
  end

  test "写真一覧が表示できること" do
    get "/"
    assert_response :success
  end

  test "h1に写真一覧と記載されていること" do
    get "/"
    assert_select "h1", "写真一覧"
  end

  test "｢ログアウト｣リンクがあること" do
    get "/"
    assert_select "a.logout-link", "ログアウト"
  end

  test "MyTweetAppに未ログインの場合は、｢MyTweetAppと連携｣リンクがあること" do
    get "/"
    assert_select "a.tweet-auth-link", "MyTweetAppと連携"
  end

  test "MyTweetAppにログイン済みの場合は｢MyTweetAppと連携中｣と表示されること" do
    stub_request(:post, ENV.fetch('TWEET_APP_AUTH_URL') + '/oauth/token')
      .to_return(body: '{"access_token": "sample_access_token"}')
    get "/oauth/callback?code=test"

    get "/"
    assert_select "body > div:nth-child(3) > span", "MyTweetAppと連携中"
  end

  test "｢写真の選択してアップロード｣リンクがあること" do
    get "/"
    assert_select "a.photo-upload-link", "写真の選択してアップロード"
  end

  test "画像が2つ表示されること" do
    get "/"
    assert_select ".photo", 2
  end

  test "投稿したタイトル｢one｣が表示されること" do
    get "/"
    assert_select ".photoLabel", "one"
  end

  test "投稿したタイトル｢two｣が表示されること" do
    get "/"
    assert_select ".photoLabel", "two"
  end

  test "画像をアップロードすると追加されること" do
    post "/photos", params: { photo: { title: "test", image: Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'three.png'), 'image/png') } }
    follow_redirect!
    assert_select ".photoLabel", "test"
    assert_select ".photo", 3
  end

  test "h1に写真アップロードと記載されていること" do
    get "/photos/new"
    assert_select "h1", "写真アップロード"
  end

  test "タイトルの入力欄があること" do
    get "/photos/new"
    assert_select "form input[name='photo[title]']"
  end

  test "ファイルの選択欄があること" do
    get "/photos/new"
    assert_select "form input[type=file]"
  end

  test "formのsubmitボタンがアップロードになっていること" do
    get "/photos/new"
    assert_select "form input[type=submit][value=?]", "アップロード"
  end

  test "フォームのPOST先が/photosであること" do
    get "/photos/new"
    assert_select "form[action=?]", "/photos"
  end

  test "キャンセルリンクがあること" do
    get "/photos/new"
    assert_select "a.photos-link", "キャンセル"
  end

  test "タイトルが未入力の場合に｢ユーザーIDを入力してください｣と表示されること" do
    post "/photos", params: { photo: { title: "", image: Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'three.png'), 'image/png') } }
    assert_select "ul > li", "タイトルを入力してください"
  end

  test "タイトルが30文字以上の場合に｢タイトルは30文字以内で入力してください｣と表示されること" do
    post "/photos", params: { photo: { title: "この文章はダミーです。文字の大きさ、量、字間、行間等を確認する", image: Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'three.png'), 'image/png') } }
    assert_select "ul > li", "タイトルは30文字以内で入力してください"
  end

  test "画像が未選択の場合に｢画像ファイルを入力してください｣と表示されること" do
    post "/photos", params: { photo: { title: "test", image: nil } }
    assert_select "ul > li", "画像ファイルを入力してください"
  end

  test "未ログイン時写真アップロード画面にアクセスするとログイン画面にリダイレクトされること" do
    get "/logout"
    get "/photos/new"
    assert_redirected_to login_path
  end
end
